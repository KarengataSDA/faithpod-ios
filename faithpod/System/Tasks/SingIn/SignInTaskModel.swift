import SwiftUI

struct SignInTaskModel {
    let email: String
    let password: String
    let deviceToken: String?
    
}

extension PostSignInRequest.Payload {
    init(taskModel: SignInTaskModel) {
        self.init(email: taskModel.email,
                  password: taskModel.password,
                  deviceToken: taskModel.deviceToken)
    }
}
