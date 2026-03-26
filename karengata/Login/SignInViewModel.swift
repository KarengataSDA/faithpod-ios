import SwiftUI
import Combine

class SignInModel : ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}

class SignInViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks
    @Environment(\.dependencies.state.sessionStore) var sessionStore
    
    @Published var model = SignInModel()
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    var dismissalPublisher = PassthroughSubject<Bool, Never>()
    
    private var shouldDismissView = false {
        didSet {
            dismissalPublisher.send(shouldDismissView)
        }
    }
    
    func handleSignIn() {
        isLoading = true
        
        let taskModel = SignInTask.Model(email: model.email,
                                         password: model.password,
                                         deviceToken: sessionStore.currentAuthToken.value)
        
        let task = tasks.initialize(SignInTask.self)
        
        return task.execute(with: taskModel)
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { response in
                switch response {
                case .finished:
                    break
                    
                case .failure(let error):
                    self.isLoading = false
                    
                    print("error is", error)
                    if !self.tasks.displayAlert(error: error) {
                        self.error = error
                    }
                }
            }, receiveValue: { response in
                self.getCustomerMe()
                    print("success login")
            }))
    }
    
    
    func getCustomerMe() {
        isLoading = true
        
        let task = tasks.initialize(GetCustomerMeTask.self)
        
        return task.execute()
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers.Sink(receiveCompletion: { response in
                switch response {
                case .finished:
                    self.shouldDismissView = true
                    self.isLoading = false 
                    
                case .failure(let error):
                    self.isLoading = false
                    
                    if !self.tasks.displayAlert(error: error) {
                        self.error = error
                    }
                }
            }, receiveValue: { _ in }))
    }
}
