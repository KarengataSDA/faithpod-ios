import SwiftUI
import Combine

struct SignInView: View {
    @Environment(\.dependencies.tasks) var tasks
    @Environment(\.dismiss) var dismiss

    var nestedNavigationAction: (() -> Void) = {}
    var isSignInRootView: Bool = false
    var isSignInNestedNavigationView: Bool = false
    var isSecondInStack: Bool = false

    @State private var isPasswordVisble = false
    @FocusState private var isInputActive: Bool

    var dismissalPublisher = PassthroughSubject<Bool, Never>()

    @ObservedObject var viewModel = SignInViewModel()

    var body: some View {
        if isSignInRootView {
            BaseNavigationView {
                contentView()
            }
            .loadingOverlay($viewModel.isLoading)
            .errorAlert(error: $viewModel.error)
            .consolidatedAlertSheet()
            .onReceive(dismissalPublisher) { _ in
                nestedNavigationAction()
                dismiss()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)

        } else if isSignInNestedNavigationView {
            VStack(alignment: .leading) {
                navBarLogo()
                    .padding(.leading, 8)

                contentView()
                    .loadingOverlay($viewModel.isLoading)
                    .errorAlert(error: $viewModel.error)
                    .consolidatedAlertSheet()
                    .onReceive(viewModel.dismissalPublisher) { _ in
                        nestedNavigationAction()
                        dismiss()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
            }

        } else {
            VStack {
                HStack {
                    navBarLogo()
                    Spacer()
                }

                contentView()
                    .navigationBarBackButtonHidden(true)
            }
            .onReceive(viewModel.dismissalPublisher) { _ in
                nestedNavigationAction()
                dismiss()
            }
        }
    }

    // MARK: - Content View
    private func contentView() -> some View {
        ScrollView {
            VStack(spacing: 24) {

                Image("vertical-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 16) {

                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                        TextField("Email Address", text: $viewModel.model.email)
                            .autocapitalization(.none)
                            .focused($isInputActive)
                            .padding(7)
                            .border(Color("Green"))
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")

                        HStack {
                            Group {
                                if isPasswordVisble {
                                    TextField("Password", text: $viewModel.model.password)
                                } else {
                                    SecureField("Password", text: $viewModel.model.password)
                                }
                            }
                            .autocapitalization(.none)
                            .focused($isInputActive)
                            .padding(7)

                            Button {
                                isPasswordVisble.toggle()
                            } label: {
                                Image(systemName: isPasswordVisble ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color("Green"))
                                    .padding(10)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color("Green"), lineWidth: 1)
                        )
                    }

                    // Forgot Password
                    HStack {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.system(size: 14))
                                .foregroundColor(Color("Green"))
                        }
                        Spacer()
                    }

                    // Login Button
                    Button {
                        isInputActive = false
                        viewModel.handleSignIn()
                    } label: {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 45)
                    }
                    .background(Color("Green"))
                    .cornerRadius(5)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Nav Bar Logo
    private func navBarLogo() -> some View {
        HStack {
            NavigationBackButton(
                nestedNavigationAction: isSignInNestedNavigationView ? nestedNavigationAction : nil
            )
            Spacer()
        }
        .padding([.top, .bottom], 5)
        .frame(width: 100)
        .padding(.leading, 20)
    }
}
