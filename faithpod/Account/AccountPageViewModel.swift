import SwiftUI

class AccountPageViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks

    func titleText(for customer: Customer?) -> String {
        guard let firstName = customer?.firstName,
              let lastName = customer?.lastName else {
            return String(localized: "Name")
        }

        return "\(firstName) \(lastName)"
    }

    func handleLogoutRequest() {
        let task = tasks.initialize(SignOutTask.self)
        task.execute()
    }
}
