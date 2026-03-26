import Foundation

struct GetGroupsPayload: Encodable {}

struct GetGroupsRequest: HTTPRequest {
    typealias Payload = GetGroupsPayload
    typealias Response = [PopulationGroup]

    let path: HTTPEndpoint = FaithpodEndpoint.groups
    let method = HTTPMethod.GET
    var body: Payload?
}
