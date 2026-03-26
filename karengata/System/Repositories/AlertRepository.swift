import Foundation
import Combine

class AlertRepository: Repository, ObservableObject {
    private let store: AlertStore
    
    init(store: AlertStore) {
        self.store = store
    }
    
    func storeAlertMessage(taskModel: DisplayAlertMessageTask.Model) {
        store.storeMessage(taskModel.alertMessage)
    }
    
    func clearAlerts() {
        store.clear()
    }
}
