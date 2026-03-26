import SwiftUI
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks

    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var error: Error?

    var dismissalPublisher = PassthroughSubject<Bool, Never>()

    private var shouldDismissView = false {
        didSet {
            dismissalPublisher.send(shouldDismissView)
        }
    }

    func handleForgotPassword() {
        guard !email.isEmpty else {
            return
        }

        isLoading = true

        let taskModel = ForgotPasswordTaskModel(email: email)
        let task = tasks.initialize(ForgotPasswordTask.self)

        task.execute(with: taskModel)
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false

                switch response {
                case .finished:
                    break

                case .failure(let error):
                    if !self.tasks.displayAlert(error: error) {
                        self.error = error
                    }
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                let message = response.message ?? "Password reset link has been sent to your email."
                self.tasks.displayAlert(message: message, style: .success)
                self.shouldDismissView = true
            }))
    }
}
