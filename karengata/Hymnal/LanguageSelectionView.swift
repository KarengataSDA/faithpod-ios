import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var authStatus: AuthStatus
    @EnvironmentObject private var viewModel: HymnalViewModel
    @State private var searchText = ""
    @State private var navigationPath = NavigationPath()

    private var filteredLanguages: [HymnalLanguage] {
        if searchText.isEmpty {
            return viewModel.languages
        }
        return viewModel.languages.filter { language in
            language.name.localizedCaseInsensitiveContains(searchText) ||
            language.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search languages...", text: $searchText)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()

                // Section header
                Text("Available Hymnals")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                if viewModel.isLoadingLanguages {
                    Spacer()
                    ProgressView("Loading languages...")
                    Spacer()
                } else if filteredLanguages.isEmpty {
                    Spacer()
                    Text("No languages available")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(filteredLanguages) { language in
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(language.color)
                                .frame(width: 32, height: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(language.name)
                                    .font(.headline)
                                Text(language.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if language.hymnsCount > 0 {
                                Text("\(language.hymnsCount)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            navigationPath.append(language)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HymnalLanguage.self) { language in
                HymnListView(language: language)
            }
        }
    }
}
