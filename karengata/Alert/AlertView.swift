import SwiftUI

struct AlertView: View {
    let title: String
    let message: String
    let systemImage: String
    let color: Color
    let confirmText: String
    let onDismiss: () -> Void
    
    
    @State private var appearScale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 38))
                .foregroundColor(color)
                .padding()
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            VStack(spacing: 10) {
                Button(action: onDismiss) {
                    Text(confirmText)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 30)
                        .background(Color("Green"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 8)
        )
        .scaleEffect(appearScale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                appearScale = 1.0
                opacity = 1.0
            }
        }
    }
}

struct BlurBackground: View {
    @State private var blurAmount: CGFloat = 0
    
    var body: some View {
        Color.black.opacity(0.5)
            .blur(radius: 3)
            .ignoresSafeArea()
            .opacity(blurAmount)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.2)) {
                    blurAmount = 1
                }
            }
    }
}

#Preview {
    Group {
        AlertView(title: "🎉 Payment Successful",
                  message: "Your contribution has been submitted. Thank you!",
                  systemImage: "checkmark.seal.fill",
                  color: Color("Green"), confirmText: "OK") { }
        
        AlertView(
            title: "😓 Payment Failed",
            message: "Your contribution has been submitted. Thank you!",
            systemImage: "xmark.octagon.fill",
            color: .red,
            confirmText: "Ok") {}
    }
}
