struct GetCustomerMeRequest: HTTPRequest {
    typealias Payload = GetCustomerMePayload
    typealias Response = GetCustomerMeResponse
    
    let path: HTTPEndpoint = FaithpodEndpoint.customers_me
    let method = HTTPMethod.GET
    var body: Payload?
}
