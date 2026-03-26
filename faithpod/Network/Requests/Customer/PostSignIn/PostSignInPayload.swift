import Foundation
import UIKit

struct PostSignInPayload: Encodable{
    struct DeviceInfo: Encodable {
        let os_version: String?
        let device_model: String?
        let device_token: String?
        let os_name: String = "iPhone OS"
    }
    
    let email: String
    let password: String
    let device_info: DeviceInfo?
    
    init(email: String, password: String, deviceToken: String?) {
        self.email = email
        self.password = password
        
        if let deviceToken = deviceToken {
            let device = UIDevice.current
            
            self.device_info = DeviceInfo(os_version: device.systemVersion, device_model: device.model, device_token: deviceToken)
        } else {
            self.device_info = nil
        }
    }
}
