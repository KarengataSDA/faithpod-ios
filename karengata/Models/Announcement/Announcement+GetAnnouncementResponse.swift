import Foundation

extension Announcement {
    init(response: AnnouncementResponse) {
        self.id = response.id
        self.title = response.title
        self.body = response.body
        self.image = response.image
    }
}

