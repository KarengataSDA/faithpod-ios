import Foundation
import Combine

struct AlertStore {
    var messageForDisplay = CurrentValueSubject<AlertMessage?, Never>(nil)
    
    init() {
        clear()
    }
    
    func storeMessage(_ message: AlertMessage?)
    {
        messageForDisplay.send(message)
    }
    
    func clearMessage() {
        messageForDisplay.send(nil)
    }
    
    func clear() {
        clearMessage()
    }
}
