import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var contributionViewModel: ContributionsTypeViewModel
    @StateObject private var paymentViewModel: PaymentViewModel

    init(contributionViewModel: ContributionsTypeViewModel) {
        self.contributionViewModel = contributionViewModel
        _paymentViewModel = StateObject(wrappedValue: PaymentViewModel(viewModel: contributionViewModel))
    }

    var body: some View {
        BaseNavigationView {
            ZStack {
                VStack {
                    VStack {
                        Image("horizontal-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 100)

                        Text(paymentViewModel.titleText)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Divider()
                        Text("Contribution Break Down")
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                            .padding()
                        Text(Date.now, formatter: DateFormatter.displayDate)
                            .foregroundColor(Color("Green"))
                        Divider()
                        VStack(spacing: 15) {
                            ForEach(contributionViewModel.contributionAmounts.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                if let amount = Double(value), amount > 0 {
                                    HStack {
                                        Text(key)
                                            .font(.system(size: 15))
                                        Spacer()
                                        Text("\(amount, specifier: "%.2f")")
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                    }
                                }
                            }

                            let total = contributionViewModel.contributionAmounts
                                .compactMap { Double($0.value) }
                                .reduce(0, +)

                            HStack {
                                Text("Total")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Green"))
                                Spacer()
                                Text("Ksh. \(total, specifier: "%.2f")")
                                    .foregroundColor(Color("Green"))
                                    .fontWeight(.bold)
                                    .font(.system(size: 18))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)

                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Text("Cancel")
                                    .foregroundColor(Color("Green"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .border(Color("Green"))
                            }
                            Spacer()
                            Button {
                                paymentViewModel.makeContributions()
                            } label: {
                                Text("Pay")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color("Green"))
                            }
                            .cornerRadius(5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                    }
                    Spacer()
                }
               
                // Loading overlay
                if paymentViewModel.isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    CustomProgressView()
                }
                
                if paymentViewModel.showSuccessAlert{
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    AlertView(
                        title: "🎉 Payment Successful",
                        message: "Your contribution has been submitted. Thank you!",
                        systemImage: "checkmark.seal.fill",
                        color: .green,
                        confirmText: "Ok"
                    ) {
                        paymentViewModel.showSuccessAlert = false
                        contributionViewModel.resetContributions()
                        dismiss()
                    }
                }
                
                if paymentViewModel.showErrorAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    AlertView(
                        title: "😓 Payment Failed",
                        message: paymentViewModel.errorMessage,
                        systemImage: "xmark.octagon.fill",
                        color: .red,
                        confirmText: "Ok"
                        
                    ) {
                        paymentViewModel.showErrorAlert = false
                        //dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

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
