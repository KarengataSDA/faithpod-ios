import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var authStatus: AuthStatus
    @EnvironmentObject var sessionCustomer: SessionCustomer
    @StateObject var viewModel = AccountPageViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        if authStatus.isLoggedIn {
            BaseNavigationView {
                contentView()
            }
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            SignInView(isSignInRootView: true)
        }
    }

    private func contentView() -> some View {
        VStack {
            VStack {
                Text(viewModel.titleText(for: sessionCustomer.customer))
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding()

                Divider()

                VStack {
                    NavigationLink(destination: ProfilePageView()) {
                        HStack {
                            Text("Profile")
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                        .foregroundColor(.gray)
                        .padding()
                    }

                    NavigationLink(destination: TransactionHistory()) {
                        HStack {
                            Text("History")
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                        .foregroundColor(.gray)
                        .padding()
                    }

                    logoutButton()
                }
            }

            Spacer()
            socialIcons()
        }
    }

    // MARK: - Social Icons

    private func socialIcons() -> some View {
        HStack(spacing: 24) {

            socialButton(
                imageName: "facebook",
                urlString: "https://www.facebook.com/faithpodchurch/"
            )

            socialButton(
                imageName: "youtube",
                urlString: "https://www.youtube.com/@FaithpodSDA"
            )

            socialButton(
                imageName: "instagram",
                urlString: "https://www.instagram.com/faithpodsda/"
            )
            
            socialButton(
                imageName: "sabbath-school",
                urlString: "https://www.fustero.es/en_2026t1.pdf",
                width: 50,
                height: 50
            )
        }
        .padding()
    }

    private func socialButton(
        imageName: String,
        urlString: String,
        width: CGFloat = 25,
        height: CGFloat = 25
    ) -> some View {
        Button {
            if let url = URL(string: urlString) {
                openURL(url)
            }
        } label: {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color("Green"))
                .scaledToFit()
                .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Logout

    private func logoutButton() -> some View {
        HStack {
            Button {
                viewModel.handleLogoutRequest()
            } label: {
                Text("LOGOUT")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Green"))
                    .font(.system(size: 14))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccountPageView()
}
