import Foundation

struct ContributionsRequest: HTTPRequest {
    
    typealias Payload = ContributionsPayload
    typealias Response = PostContributionsResponse
    
    init(payload: Payload) {
        body = payload
    }
    
    let path: HTTPEndpoint = KSDAEndpoint.make_contributions
    let method = HTTPMethod.POST
    var body: Payload?
}
