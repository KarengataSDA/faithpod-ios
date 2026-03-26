import SwiftUI
import Combine

class HymnalViewModel: ObservableObject {
    @Environment(\.dependencies.tasks) var tasks

    @Published var languages: [HymnalLanguage] = []
    @Published var hymns: [Hymn] = []
    @Published var favoriteIds: Set<Int> = []
    @Published var isLoadingLanguages = false
    @Published var isLoadingHymns = false
    @Published var isLoadingFavorites = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchLanguages()
        fetchHymns()
    }

    // MARK: - Fetch Languages

    func fetchLanguages() {
        isLoadingLanguages = true
        errorMessage = nil

        tasks.initialize(GetHymnLanguagesTask.self)
            .execute()
            .sink { [weak self] completion in
                self?.isLoadingLanguages = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] languages in
                self?.languages = languages
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Hymns

    func fetchHymns() {
        isLoadingHymns = true

        tasks.initialize(GetHymnsTask.self)
            .execute()
            .sink { [weak self] completion in
                self?.isLoadingHymns = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] hymns in
                self?.hymns = hymns
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Favorites

    func fetchFavorites() {
        isLoadingFavorites = true

        tasks.initialize(GetHymnFavoritesTask.self)
            .execute()
            .sink { [weak self] completion in
                self?.isLoadingFavorites = false
                if case .failure(let error) = completion {
                    print("Error fetching favorites: \(error)")
                }
            } receiveValue: { [weak self] favorites in
                self?.favoriteIds = Set(favorites.map { $0.id })
            }
            .store(in: &cancellables)
    }

    // MARK: - Helpers

    func hymns(for languageId: Int) -> [Hymn] {
        hymns.filter { $0.languageId == languageId }
    }

    func isFavorite(_ hymnId: Int) -> Bool {
        favoriteIds.contains(hymnId)
    }

    func favoriteHymns(for languageId: Int) -> [Hymn] {
        hymns(for: languageId).filter { isFavorite($0.id) }
    }

    // MARK: - Toggle Favorite

    func toggleFavorite(_ hymnId: Int) {
        let wasInFavorites = favoriteIds.contains(hymnId)
        if wasInFavorites {
            favoriteIds.remove(hymnId)
        } else {
            favoriteIds.insert(hymnId)
        }

        tasks.initialize(ToggleHymnFavoriteTask.self)
            .execute(with: hymnId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    // Revert optimistic update on failure
                    if wasInFavorites {
                        self?.favoriteIds.insert(hymnId)
                    } else {
                        self?.favoriteIds.remove(hymnId)
                    }
                    print("Error toggling favorite: \(error)")
                }
            } receiveValue: { [weak self] isFavorite in
                // Sync with server response
                if isFavorite {
                    self?.favoriteIds.insert(hymnId)
                } else {
                    self?.favoriteIds.remove(hymnId)
                }
            }
            .store(in: &cancellables)
    }

    func clearFavorites() {
        favoriteIds = []
    }
}
