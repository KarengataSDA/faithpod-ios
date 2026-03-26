import SwiftUI

struct HomeView: View {
    @State var isContributionPresented: Bool = false
    
    @EnvironmentObject var authStatus: AuthStatus
    @EnvironmentObject var sessionCustomer: SessionCustomer
    
    var body: some View {
        BaseNavigationView {
            VStack(alignment: .leading) {
                headerSection()
                ScrollView {
                    HomeCarousel()
                        .transition(.move(edge: .trailing))
                        .animation(.easeIn, value: 0.5)
                        .padding(.bottom, 16)
                    ctaContribution()
                        .padding(.bottom, 16)
                    AnnouncementHubView()
                }
                
            }
        }
        .padding(.top, 16)
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $isContributionPresented) {
            ContributionView(showCloseButton: true)
        }
    }
    
    private func headerSection() -> some View {
        HStack {
            Text(String.localizedStringWithFormat(NSLocalizedString("HomePage.Label.WelcomeMessage", comment: "HomePage.Label.WelcomeMessage"), authStatus.isLoggedIn ? sessionCustomer.customer?.firstName ?? String(localized: "HomePage.Label.WelcomeMessageGuest") : String(localized: "HomePage.Label.WelcomeMessageGuest")))
                .fontWeight(.bold)
                .font(.system(size: 26))
            
        }
        .padding(.horizontal, 12)
    }
    
    private func ctaContribution() -> some View  {
        VStack {
            Button {
                // todo
                isContributionPresented = true
            } label: {
                Text("Make Contributions")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                
                    .frame(height: 45)
                    .background(Color("Green"))
                
            }
            .cornerRadius(5)
        }
        .padding(.horizontal, 12)
        
    }
}

