import Foundation

struct GetGroupsPayload: Encodable {}

struct GetGroupsRequest: HTTPRequest {
    typealias Payload = GetGroupsPayload
    typealias Response = [PopulationGroup]

    let path: HTTPEndpoint = KSDAEndpoint.groups
    let method = HTTPMethod.GET
    var body: Payload?
}
