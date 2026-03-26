import SwiftUI

struct UpdateBannerView: View {
    @ObservedObject var updateService = AppUpdateService.shared

    var body: some View {
        if updateService.shouldShowUpdateBanner {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.down.app.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color("Green"))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Update Available")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)

                        Text("Version \(updateService.latestVersion) is now available")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        updateService.openAppStore()
                    } label: {
                        Text("Update")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color("Green"))
                            .cornerRadius(16)
                    }

                    Button {
                        withAnimation {
                            updateService.dismissUpdate()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                Divider()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

struct UpdateBannerModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            UpdateBannerView()
            content
        }
    }
}

extension View {
    func withUpdateBanner() -> some View {
        modifier(UpdateBannerModifier())
    }
}
