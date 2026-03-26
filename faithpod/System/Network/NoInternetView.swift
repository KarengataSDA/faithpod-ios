import SwiftUI

struct NoInternetText: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            Text("No internet connection")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct NetworkAwareContent<Content: View, OfflineContent: View>: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    let content: () -> Content
    let offlineContent: () -> OfflineContent

    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder offlineContent: @escaping () -> OfflineContent) {
        self.content = content
        self.offlineContent = offlineContent
    }

    var body: some View {
        if networkMonitor.isConnected {
            content()
        } else {
            offlineContent()
        }
    }
}

#Preview {
    NoInternetText()
}
