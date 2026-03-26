import SwiftUI

struct ContributionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ContributionsTypeViewModel()
    @ObservedObject var networkMonitor = NetworkMonitor.shared

    @EnvironmentObject var authStatus: AuthStatus

    let showCloseButton: Bool

    @State private var showPaymentView = false
    @State private var contributionBreakdown: [String: String] = [:]

    @State private var isLoading = false

    var body: some View {
        BaseNavigationView {
            VStack {
                Image("horizontal-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 100)

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Make Contributions")
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .padding()

                        if !networkMonitor.isConnected {
                            NoInternetText()
                                .padding(.horizontal)
                        }
                        
                        VStack(spacing: 20) {
                            if authStatus.isLoggedIn {
                                ForEach(viewModel.sortedContributionTypes.filter {!$0.archived}, id: \.self) { contributionType in
                                    HStack {
                                        Text(contributionType.name ?? "")
                                        Spacer()
                                        
                                        TextFieldWithDoneButton(text: Binding(
                                            get: {
                                                viewModel.contributionAmounts[contributionType.name ?? ""] ?? ""
                                            },
                                            set: {
                                                viewModel.contributionAmounts[contributionType.name ?? ""] = $0
                                            }
                                        ), placeholder: "amount")
                                        
                                        .padding(7)
                                        .border(Color("Green"))
                                        .frame(width: 100)
                                        .keyboardType(.numberPad)
                                    }
                                }
                                
                            } else {
                                Text("Please Login to Continue")
                            }
                            
                            VStack(alignment: .leading) {
                                Button {
                                    contributionBreakdown = viewModel.contributionAmounts
                                    showPaymentView = true
                                } label: {
                                    Text("Make Payment")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background( authStatus.isLoggedIn ? Color("Green") : Color.gray)
                                }
                                .cornerRadius(5)
                                .disabled(!authStatus.isLoggedIn)
                            }
                            .padding(.top, 15)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showCloseButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        closeButton()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showPaymentView) {
            PaymentView(contributionViewModel: viewModel)
        }
        .loadingOverlay(authStatus.isLoggedIn ? $viewModel.isLoading : .constant(false))
        .consolidatedAlertSheet()
    }
    
    
    private func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.bold))
                .foregroundColor(Color("Green"))
                .frame(width: 15, height: 15)
        }
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
