import SwiftUI

struct AnnouncementDetailsView: View {
    let announcement: Announcement
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 11) {
                AsyncImage(url: URL(string: announcement.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 350)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 350)
                            .clipShape(
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                            )
                        
                    case .failure:
                        Image("no_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 350)
                            .clipShape(
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                            )
                    }
                }
                
                Text(announcement.title)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                
                Text(announcement.body)
                    .font(.system(size: 14))
                
                    .lineSpacing(7)
            }
            .padding(.horizontal, 16)
            .navigationBarBack(title: "Announcement")
        }
    }
}
