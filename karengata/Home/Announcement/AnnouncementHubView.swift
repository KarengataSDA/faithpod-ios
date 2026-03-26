import SwiftUI

struct AnnouncementHubView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = AnnouncementViewModel()
    @ObservedObject var networkMonitor = NetworkMonitor.shared

    var body: some View {
            ScrollView {
                VStack( spacing: 24) {
                    if !networkMonitor.isConnected {
                        NoInternetText()
                    }
                    ForEach(viewModel.announcements) { announcement  in
                        announcementCard(announcement)
                    }
                }
            }
    }
    
    private func announcementCard(_ announcement: Announcement) -> some View  {
        VStack(alignment: .leading, spacing: 16) {
            
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
                @unknown default:
                    EmptyView()
                }
            }
            .allowsHitTesting(false)
            
            
            Text(announcement.title)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.horizontal, 16)
            
            
            Text(announcement.body.truncated(to: 150))
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .lineSpacing(7)
            
            NavigationLink(destination: AnnouncementDetailsView(announcement: announcement)) {
                Text("Read More")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white)
                    .frame(width: 100)
                    .frame(height: 35)
                    .background(Color("Green"))
                    .cornerRadius(5)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Gray"), lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }
    
}
