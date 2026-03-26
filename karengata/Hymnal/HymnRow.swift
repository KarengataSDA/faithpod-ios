import SwiftUI

struct HymnRow: View {
    let hymn: Hymn
    let isFavorite: Bool
    let isLoggedIn: Bool
    let onFavoriteToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(hymn.formattedNumber)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color("Green"))
                .padding(8)
                .background(Color("Green").opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(hymn.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(hymn.firstLine)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if isLoggedIn {
                Button {
                    onFavoriteToggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "heart.slash")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
