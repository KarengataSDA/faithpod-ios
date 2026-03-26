
import Foundation


struct GetAnnouncementRequest: HTTPRequest {
    typealias Payload = GetAnnouncementPayload
    typealias Response = [AnnouncementResponse]
    
    let path: HTTPEndpoint = KSDAEndpoint.get_announcements
    let method = HTTPMethod.GET
    var body: Payload?
}



