import SwiftUI

struct HymnListView: View {
    let language: HymnalLanguage
    @EnvironmentObject var authStatus: AuthStatus
    @EnvironmentObject private var viewModel: HymnalViewModel
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var selectedHymnIndex: Int = 0
    @State private var showDetails = false

    private var hymns: [Hymn] {
        viewModel.hymns(for: language.id)
    }

    private var filteredHymns: [Hymn] {
        var result = hymns

        if showFavoritesOnly {
            result = result.filter { viewModel.isFavorite($0.id) }
        }

        if !searchText.isEmpty {
            result = result.filter { hymn in
                hymn.title.localizedCaseInsensitiveContains(searchText) ||
                hymn.formattedNumber.contains(searchText) ||
                String(hymn.number).contains(searchText)
            }
        }

        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Filter", selection: $showFavoritesOnly) {
                Text("All Hymns").tag(false)
                Text("Favorites").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 8)

            contentView
        }
        .navigationTitle(language.name)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search by number or title")
        .navigationDestination(isPresented: $showDetails) {
            HymnDetailsView(hymns: hymns, startIndex: selectedHymnIndex)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if showFavoritesOnly && !authStatus.isLoggedIn {
            loginPromptView
        } else if viewModel.isLoadingHymns {
            Spacer()
            ProgressView("Loading hymns...")
            Spacer()
        } else if filteredHymns.isEmpty {
            emptyStateView
        } else {
            hymnListView
        }
    }

    private var hymnListView: some View {
        List(filteredHymns) { hymn in
            hymnRow(for: hymn)
        }
        .listStyle(.plain)
    }

    private func hymnRow(for hymn: Hymn) -> some View {
        let loggedIn = authStatus.isLoggedIn
        let favorite = viewModel.isFavorite(hymn.id)
        return HymnRow(
            hymn: hymn,
            isFavorite: favorite,
            isLoggedIn: loggedIn,
            onFavoriteToggle: {
                viewModel.toggleFavorite(hymn.id)
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if let index = hymns.firstIndex(where: { $0.id == hymn.id }) {
                selectedHymnIndex = index
                showDetails = true
            }
        }
    }

    private var loginPromptView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Please login to add hymns to your favorites")
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: showFavoritesOnly ? "heart.slash" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text(showFavoritesOnly ? "No favorites yet" : "No hymns found")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(showFavoritesOnly
                 ? "Tap the heart icon on any hymn to add it to your favorites"
                 : "Try a different search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}
