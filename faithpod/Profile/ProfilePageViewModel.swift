import Combine
import SwiftUI

class ProfilePageViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks

    @Published var isLoading: Bool = false
    @Published var isLoadingDropdowns: Bool = true
    @Published var error: Error?

    @Published var firstName: String = ""
    @Published var middleName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var birthDate: Date = Date()
    @Published var gender: String = ""
    @Published var selectedPrayerCellId: Int?
    @Published var selectedPopulationGroupId: Int?

    @Published var populationGroups: [PopulationGroup] = []
    @Published var prayerCells: [PrayerCell] = []

    let genderOptions = ["Male", "Female"]

    private var hasBirthDate: Bool = false
    private var hasLoaded: Bool = false
    private var pendingCustomer: Customer?
    private var groupsLoaded: Bool = false
    private var prayerCellsLoaded: Bool = false

    init() {}

    func loadData(customer: Customer?) {
        guard !hasLoaded else { return }
        hasLoaded = true
        pendingCustomer = customer
        isLoadingDropdowns = true
        fetchDropdownData()
    }

    private func checkAndLoadCustomerData() {
        if groupsLoaded && prayerCellsLoaded {
            isLoadingDropdowns = false
            if let customer = pendingCustomer {
                updateCustomerData(customer: customer)
            }
        }
    }

    func updateCustomerData(customer: Customer?) {
        self.firstName = customer?.firstName ?? ""
        self.middleName = customer?.middleName ?? ""
        self.lastName = customer?.lastName ?? ""
        self.email = customer?.email ?? ""
        self.phoneNumber = customer?.phoneNumber ?? ""
        self.gender = customer?.gender ?? ""
        self.selectedPrayerCellId = customer?.prayercellId
        self.selectedPopulationGroupId = customer?.populationGroupId

        if let dateString = customer?.birthDate, !dateString.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateString) {
                self.birthDate = date
                self.hasBirthDate = true
            }
        }
    }

    var titleText: String {
        return "\(firstName) \(lastName)"
    }

    var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: birthDate)
    }

    func fetchDropdownData() {
        fetchPopulationGroups()
        fetchPrayerCells()
    }

    func fetchPopulationGroups() {
        let task = tasks.initialize(GetGroupsTask.self)

        task.execute()
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { [weak self] response in
                if case .failure(let error) = response {
                    print("Failed to fetch groups: \(error)")
                }
                self?.groupsLoaded = true
                self?.checkAndLoadCustomerData()
            }, receiveValue: { [weak self] groups in
                self?.populationGroups = groups
            }))
    }

    func fetchPrayerCells() {
        let task = tasks.initialize(GetPrayerCellsTask.self)

        task.execute()
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { [weak self] response in
                if case .failure(let error) = response {
                    print("Failed to fetch prayer cells: \(error)")
                }
                self?.prayerCellsLoaded = true
                self?.checkAndLoadCustomerData()
            }, receiveValue: { [weak self] cells in
                self?.prayerCells = cells
            }))
    }

    func handleProfileUpdate() {
        self.isLoading = true

        let taskModel = UpdateCustomerTask.Model(
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
            dateOfBirth: formattedBirthDate,
            gender: gender,
            prayercellId: selectedPrayerCellId,
            populationGroupId: selectedPopulationGroupId
        )
        let task = tasks.initialize(UpdateCustomerTask.self)

        task.execute(with: taskModel)
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { [weak self] response in
                self?.isLoading = false
                switch response {
                case .finished:
                    break

                case .failure(let error):
                    self?.error = error
                }
            }, receiveValue: { [weak self] response in
                self?.updateCustomerData(customer: response)
                self?.tasks.displayAlert(message: String(localized: "Saved"), style: .success)
            }))
    }
}
