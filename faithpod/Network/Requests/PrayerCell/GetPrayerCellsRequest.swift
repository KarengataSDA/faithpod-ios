import Foundation

struct GetPrayerCellsPayload: Encodable {}

struct GetPrayerCellsRequest: HTTPRequest {
    typealias Payload = GetPrayerCellsPayload
    typealias Response = [PrayerCell]

    let path: HTTPEndpoint = FaithpodEndpoint.prayercells
    let method = HTTPMethod.GET
    var body: Payload?
}
