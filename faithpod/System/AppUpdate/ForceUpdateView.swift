import SwiftUI

struct ForceUpdateView: View {
    @ObservedObject var updateService = AppUpdateService.shared

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "arrow.down.app.fill")
                .font(.system(size: 80))
                .foregroundColor(Color("Green"))

            VStack(spacing: 8) {
                Text("Update Required")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)

                Text("A new version of the app is available. Please update to continue using the app.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 4) {
                Text("Current version: \(updateService.currentVersion)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                Text("Latest version: \(updateService.latestVersion)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            if let releaseNotes = updateService.releaseNotes, !releaseNotes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's New:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)

                    ScrollView {
                        Text(releaseNotes)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 150)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 24)
            }

            Spacer()

            Button {
                updateService.openAppStore()
            } label: {
                Text("Update Now")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("Green"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    ForceUpdateView()
}
