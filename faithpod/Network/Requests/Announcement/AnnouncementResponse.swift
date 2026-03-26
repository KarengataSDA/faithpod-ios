import Foundation

//struct GetAnnouncementResponse: Decodable {
//    let announcements: [AnnouncementResponse]
//}

struct AnnouncementResponse: Decodable {
    let id: Int
    let title: String
    let body: String
    let image: String
}
