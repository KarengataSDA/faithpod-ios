import Foundation

struct PutCustomerRequest: HTTPRequest {
    typealias Payload = PutCustomerPayload
    typealias Response = PutCustomerResponse
    
    var path: HTTPEndpoint {
        return KSDAEndpoint.customers_update
    }
    
    init(payload: Payload) {
        self.body = payload
    }
    
    let method: HTTPMethod = HTTPMethod.PUT
    var body: Payload?
}
