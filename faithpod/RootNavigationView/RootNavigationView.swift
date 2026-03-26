import SwiftUI

struct RootNavigationView: View {
    @EnvironmentObject var authStatus: AuthStatus
    @Binding var selectedTab: Tab
    @StateObject private var hymnalViewModel = HymnalViewModel()

    var body: some View {
        VStack {
            selectedView()
            tabBar()
        }
        .ignoresSafeArea(.keyboard)
        .environmentObject(hymnalViewModel)
        .onAppear {
            if authStatus.isLoggedIn {
                hymnalViewModel.fetchFavorites()
            }
        }
        .onChange(of: authStatus.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                hymnalViewModel.fetchFavorites()
            } else {
                hymnalViewModel.clearFavorites()
            }
        }
    }
    
    private func tabBar() -> some View {
        ZStack {

            VStack {
                Divider()
                    .foregroundColor(Color.yellow)
                HStack {
                    TabItem(
                        isSelected: selectedTab == .home,
                        title: "Home", icon: Image(systemName: "house"),
                        iconSelected: Image(systemName: "house.fill")) {
                        selectedTab = .home
                    }
                    
                    TabItem(
                        isSelected: selectedTab == .hymnal,
                        title: "Hymnal", icon: Image(systemName: "music.note.list"),
                        iconSelected: Image(systemName: "music.note.list")) {
                            selectedTab = .hymnal
                    }

                    TabItem(isSelected: selectedTab == .contribution, title: "Contribution", icon: Image(systemName: "plus.app"), iconSelected: Image(systemName: "plus.app.fill")) {
                        selectedTab = .contribution
                    }

                    TabItem(
                        isSelected: selectedTab == .account,
                        title: authStatus.isLoggedIn ? "Account" : "Login",
                        icon: Image(systemName: "person"),
                        iconSelected: Image(systemName: "person.fill")) {
                        selectedTab = .account
                    }
                }
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
        .frame(height: 49)
    }
    
    private func selectedView() -> some View {
        switch selectedTab {
        case .home:
            return AnyView(HomeView())
            
        case .hymnal:
            return AnyView(LanguageSelectionView())

        case .contribution:
            return AnyView(ContributionView(showCloseButton: false))

        case .account:
            return AnyView(AccountPageView())
        }
    }
}


