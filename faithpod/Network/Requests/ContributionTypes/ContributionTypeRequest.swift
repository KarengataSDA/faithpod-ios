struct ContributionTypeRequest: HTTPRequest {
    typealias Payload = ContributionTypePayload
    typealias Response = [ContributionTypeResponse]
    
    let path: HTTPEndpoint = KSDAEndpoint.contributions_type
    let method = HTTPMethod.GET
    var body: Payload?
    
}
