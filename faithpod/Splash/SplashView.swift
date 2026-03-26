import SwiftUI

struct SplashView: View {
    @Binding var splashCompleted: Bool
    var body: some View {
        ZStack {
            Color("Brand")
                .ignoresSafeArea()
            Image("vertical-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                splashCompleted = true
            }
        }
    
    }
}
