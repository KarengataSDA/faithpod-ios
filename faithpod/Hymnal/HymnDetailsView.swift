import SwiftUI

struct HymnDetailsView: View {
    let hymns: [Hymn]
    @EnvironmentObject var authStatus: AuthStatus
    @EnvironmentObject private var viewModel: HymnalViewModel
    @State private var currentIndex: Int
    @State private var fontSize: CGFloat = 17

    init(hymns: [Hymn], startIndex: Int) {
        self.hymns = hymns
        self._currentIndex = State(initialValue: startIndex)
    }

    private var currentHymn: Hymn {
        hymns[currentIndex]
    }

    private var isFavorite: Bool {
        viewModel.isFavorite(currentHymn.id)
    }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(hymns.enumerated()), id: \.element.id) { index, hymn in
                HymnContentView(hymn: hymn, fontSize: $fontSize)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hymn \(currentHymn.formattedNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                fontSizeControls
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .safeAreaInset(edge: .bottom) {
            hymnNavigator
        }
    }

    // MARK: - Font Size Controls

    private var fontSizeControls: some View {
        HStack(spacing: 8) {
            Button {
                withAnimation {
                    fontSize = max(12, fontSize - 2)
                }
            } label: {
                Text("A-")
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 32, height: 28)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
            }
            .disabled(fontSize <= 12)

            Button {
                withAnimation {
                    fontSize = min(32, fontSize + 2)
                }
            } label: {
                Text("A+")
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 32, height: 28)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
            }
            .disabled(fontSize >= 32)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Favorite Button

    @ViewBuilder
    private var favoriteButton: some View {
        if authStatus.isLoggedIn {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.toggleFavorite(currentHymn.id)
                }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(isFavorite ? .red : .primary)
                    .scaleEffect(isFavorite ? 1.1 : 1.0)
            }
        } else {
            Image(systemName: "heart.slash")
                .font(.system(size: 18))
                .foregroundColor(.gray)
        }
    }

    // MARK: - Bottom Navigator

    private var hymnNavigator: some View {
        HStack {
            Button {
                withAnimation {
                    currentIndex = max(0, currentIndex - 1)
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }
                .foregroundColor(Color("Green"))
                .font(.subheadline)
            }
            .disabled(currentIndex == 0)
            .opacity(currentIndex == 0 ? 0.4 : 1)

            Spacer()

            Text("\(currentIndex + 1) of \(hymns.count)")
                .font(.caption)
                .foregroundColor(Color("Green"))

            Spacer()

            Button {
                withAnimation {
                    currentIndex = min(hymns.count - 1, currentIndex + 1)
                }
            } label: {
                HStack(spacing: 4) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color("Green"))
                .font(.subheadline)
            }
            .disabled(currentIndex == hymns.count - 1)
            .opacity(currentIndex == hymns.count - 1 ? 0.4 : 1)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

// MARK: - Hymn Content View

private struct HymnContentView: View {
    let hymn: Hymn
    @Binding var fontSize: CGFloat
    @GestureState private var pinchScale: CGFloat = 1.0

    private var effectiveFontSize: CGFloat {
        min(32, max(12, fontSize * pinchScale))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Card
                VStack(spacing: 20) {
                    Text("HYMN \(hymn.formattedNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .tracking(1.4)

                    Text(hymn.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    // Verses
                    VStack(spacing: 22) {
                        ForEach(Array(hymn.verses.enumerated()), id: \.offset) { index, verse in
                            VStack(spacing: 8) {
                                if index > 0 {
                                    Divider()
                                        .padding(.bottom, 8)
                                }

                                if verse.isChorus {
                                    Text(verse.label)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                        .tracking(1)
                                } else {
                                    let stanzaNumber = hymn.verses[...index].filter { !$0.isChorus }.count
                                    Text("\(stanzaNumber)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .tracking(1)
                                }

                                Text(verse.text)
                                    .font(.system(size: effectiveFontSize))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(6)
                            }
                        }
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.08), radius: 10)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .padding(.bottom, 60)
        }
        .simultaneousGesture(
            MagnificationGesture()
                .updating($pinchScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    fontSize = min(32, max(12, fontSize * value))
                }
        )
    }
}
