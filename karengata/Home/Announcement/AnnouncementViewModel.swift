import SwiftUI
import Combine

class AnnouncementViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var announcements: [Announcement] = []
    
    init() {
        getAnnouncements()
    }
    
    func getAnnouncements() {
        isLoading = true
        
        let task = tasks.initialize(AnnouncementTask.self)
        
        return task.execute()
            .receive(on: DispatchQueue.main)
            .subscribe(Subscribers
                .Sink(receiveCompletion: { response in
                    self.isLoading = false
                    switch response {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = error
                    }
                }, receiveValue: {items in
                    self.announcements = items
                })
            )
    }
}
