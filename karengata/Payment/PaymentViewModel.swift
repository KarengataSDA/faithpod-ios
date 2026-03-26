import SwiftUI
import Combine

class PaymentViewModel: ObservableObject {
    @Environment(\.dependencies.state.sessionCustomer.customer) var customer
    @Environment(\.dependencies.tasks) var tasks
    
    private let viewModel: ContributionsTypeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    @Published var transactionStatus: TransactionStatus?
    
    private var pollingTimer: Timer?
    private var pollingAttempts = 0
    private let maxPollingAttempts = 10
    private var isPollingActive = false
    private var pollingCancellable: AnyCancellable?
    
    init(viewModel: ContributionsTypeViewModel) {
        self.viewModel = viewModel
    }
    
    var titleText: String {
        guard let firstName = customer?.firstName,
              let lastName = customer?.lastName else {
            return String(localized: "Name")
        }
        
        return firstName + " " + lastName
    }
    
    var userId: Int {
        customer?.userId ?? 0
    }
    
    func makeContributions() {
        isLoading = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: Date())
        
        let contributionItems: [ContributionItem] = viewModel.contributionAmounts.compactMap {(name, value) in
            guard let amount = Double(value), amount > 0 else { return nil }
            guard let typeId = viewModel.contributionTypes.first(where: { $0.name == name })?.id else { return nil }
            
            return ContributionItem(
                userId: userId,
                contributionTypeId: typeId,
                contributionAmount: amount,
                contributionDate: formattedDate,
                status: "1"
            )
        }
        
        let taskItems: [ContributionsTaskModel.Item] = contributionItems.map {
            ContributionsTaskModel.Item(
                userId: $0.userId,
                contributionTypeId: $0.contributionTypeId,
                contributionAmount: $0.contributionAmount,
                contributionDate: $0.contributionDate,
                status: $0.status
            )
        }
        
        let contributionTaskModel = PostContributionsTask.Model(contributions: taskItems)
        let contributionTask = tasks.initialize(PostContributionsTask.self)
        
        contributionTask.execute(with: contributionTaskModel)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self ] completion in
                guard let self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    print("contribution submitted succesfully")
                    self.startPollingTransactionStatus()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                    print("Failed to submit contribution: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                print("Received response: \(response)")
            })
            .store(in: &cancellables)
        
    }
    
    func getTransactionStatus() -> AnyPublisher<TransactionStatus, Error> {
        let task = tasks.initialize(TransactionStatusTask.self)
        
        return task.execute()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            
    }
    
    func startPollingTransactionStatus() {
        isLoading = true
        pollingAttempts = 0
        isPollingActive = true

        pollingTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let self = self, self.isPollingActive else { return }
            self.pollingAttempts += 1

            // Cancel any previous in-flight request before starting a new one
            self.pollingCancellable?.cancel()

            self.pollingCancellable = self.getTransactionStatus()
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self, self.isPollingActive else { return }
                    if case .failure(let error) = completion {
                        self.stopPolling()
                        self.errorMessage = error.localizedDescription
                        self.showErrorAlert = true
                        print("polling failed: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] status in
                    guard let self = self, self.isPollingActive else { return }
                    self.transactionStatus = status
                    print("Polling status: \(String(describing: status.status))")

                    let statusLower = status.status?.lowercased() ?? ""

                    if statusLower == "completed" {
                        self.stopPolling()
                        self.showSuccessAlert = true
                    } else if statusLower == "failed" || statusLower == "cancelled" {
                        // Handle M-Pesa transaction failure
                        self.stopPolling()
                        self.errorMessage = status.message ?? "Payment failed. Please try again."
                        self.showErrorAlert = true
                    } else if self.pollingAttempts >= self.maxPollingAttempts {
                        self.stopPolling()
                        self.errorMessage = "Payment could not be confirmed. Please try again later."
                        self.showErrorAlert = true
                    }
                })
        }
    }
    
    func stopPolling() {
        isPollingActive = false
        pollingTimer?.invalidate()
        pollingTimer = nil
        pollingCancellable?.cancel()
        pollingCancellable = nil
        isLoading = false
    }
}
