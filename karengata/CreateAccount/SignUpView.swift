import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        NavigationView {
            ScrollView {
                Image("horizontal-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                
                VStack(alignment: .leading) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("First Name")
                            TextField("First Name", text: $email)
                                .padding(7)
                                .border(Color("Green"))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Last Name")
                            TextField("Last Name", text: $email)
                                .padding(7)
                                .border(Color("Green"))
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email Address")
                            TextField("Email Address", text: $email)
                                .padding(7)
                                .border(Color("Green"))
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Phone Number")
                            TextField("Phone Number", text: $email)
                                .padding(7)
                                .border(Color("Green"))
                            
                        }
                        VStack(alignment: .leading) {
                            Text("Password")
                            TextField("Password", text: $password)
                                .padding(7)
                                .border(Color("Green"))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Confirm Password")
                            TextField("Confirm Password", text: $password)
                                .padding(7)
                                .border(Color("Green"))
                        }
                        
                        VStack(alignment: .leading) {
                            Button {
                                // todo
                            } label: {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color("Green"))
                            .padding(.horizontal)
                            HStack {
                                Text("Have an Account?")
                                NavigationLink {
                                    SignInView()
                                        .navigationBarBackButtonHidden(true)
                                } label: {
                                    Text("Sign In")
                                        .foregroundColor(Color("Green"))
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}

