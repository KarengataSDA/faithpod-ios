struct GetContributionsRequest: HTTPRequest {
    typealias Payload = GetContributionsPayload
    typealias Response = GetContributionsResponse
    
    let path: HTTPEndpoint = FaithpodEndpoint.get_user_contributions
    let method = HTTPMethod.GET
    var body: Payload?
    
    
}
