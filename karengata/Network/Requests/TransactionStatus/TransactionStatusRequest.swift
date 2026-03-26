import Foundation

struct TransactionStatusRequest: HTTPRequest {
    typealias Payload = TransactionStatusPayload
    typealias Response = TransactionStatusResponse
    
    let path: HTTPEndpoint = KSDAEndpoint.transaction_status
    let method = HTTPMethod.GET
    var body: Payload?
}


