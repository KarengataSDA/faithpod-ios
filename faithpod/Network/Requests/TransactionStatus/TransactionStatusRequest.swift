import Foundation

struct TransactionStatusRequest: HTTPRequest {
    typealias Payload = TransactionStatusPayload
    typealias Response = TransactionStatusResponse
    
    let path: HTTPEndpoint = FaithpodEndpoint.transaction_status
    let method = HTTPMethod.GET
    var body: Payload?
}


