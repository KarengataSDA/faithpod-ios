import SwiftUI

struct CustomProgressView: View {
   // var placeholder: String
   // @Binding var show: Bool
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 28) {
            Circle()
                .trim(from: 0.2, to: 1) // Creates a spinner effect
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color("Green"), Color("Green").opacity(0)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }

            Text("Processing Payment...")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 35)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 8)
                .onTapGesture {
                    withAnimation {
                      //  show.toggle()
                    }
                }
        )
    }
}


#Preview {
    CustomProgressView()
}
