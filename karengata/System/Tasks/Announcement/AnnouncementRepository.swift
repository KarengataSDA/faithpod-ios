
import Foundation
import Combine

struct AnnouncementRepository: Repository {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getAnnouncements() -> AnyPublisher<[Announcement], Error> {
        let request = GetAnnouncementRequest()
        
        return client.perform(request).tryMap {
            response  in
            let announcements = response.map {
                Announcement(response: $0)
            }
            
            //print("announcments are: \(announcements)")
            
            return announcements
        }.eraseToAnyPublisher()
        
    }
}
