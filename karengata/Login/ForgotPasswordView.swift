import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ForgotPasswordViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Forgot Password")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 20)

                    Text("Enter your email address and we'll send you a link to reset your password.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                        TextField("Email Address", text: $viewModel.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(7)
                            .border(Color("Green"))
                    }
                    .padding(.top, 20)

                    Button {
                        UIApplication.shared.endEditing()
                        viewModel.handleForgotPassword()
                    } label: {
                        Text("Send Reset Link")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .contentShape(Rectangle())
                    }
                    .background(Color("Green"))
                    .cornerRadius(5)
                    .padding(.top, 10)

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .loadingOverlay($viewModel.isLoading)
        .errorAlert(error: $viewModel.error)
        .consolidatedAlertSheet()
        .onReceive(viewModel.dismissalPublisher) { _ in
            dismiss()
        }
    }
}

#Preview {
    ForgotPasswordView()
}
