struct GetCustomerMeRequest: HTTPRequest {
    typealias Payload = GetCustomerMePayload
    typealias Response = GetCustomerMeResponse
    
    let path: HTTPEndpoint = KSDAEndpoint.customers_me
    let method = HTTPMethod.GET
    var body: Payload?
}
