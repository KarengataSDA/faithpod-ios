import SwiftUI

private struct LoadingOverlay<Content>: View where Content: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .overlay(isPresented ? overlay() : nil)
    }
    
    func overlay() -> some View {
        ZStack(alignment: .center) {
            Color.white
                .opacity(0.1)
            AnimatedLoader()
            ZStack {
                Image("vertical-logo")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: 80, height: 80)
            }
        }
        .ignoresSafeArea()
    }
}

private struct AnimatedLoader : View {
    let rotationTime: Double = 0.75
    let animationTime: Double = 1.9
    
    static let initialDegree: Angle = .degrees(270)
    let rotationAmount: Angle = .degrees(240)
    
    let initialStart: Double = 0.0
    let minSegmentLength: Double = 25.0
    
    @State var spinnerStart: Double = 0
    @State var spinnerEnd: Double = 15
    @State var spinnerRotation = initialDegree
    
    private func resetSegmentLength() {
        self.spinnerStart = initialStart
        self.spinnerEnd = initialStart + minSegmentLength
    }
    
    var body: some View {
        ZStack {
            SpinnerCircle(start: spinnerStart, end: spinnerEnd)
                .stroke(Color("Green"), style: StrokeStyle(lineWidth: 8, lineCap: .round) )
                .rotationEffect(spinnerRotation)
        }
        .frame(width: 100, height: 100)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x:0, y:15)
        .onAppear() {
            withAnimation(.linear(duration: animationTime*3).repeatForever(autoreverses: false)) {
                spinnerRotation += .degrees(720)
            }
            withAnimation(.easeInOut(duration: 1.3).delay(0.6).repeatForever(autoreverses: false)) {
                spinnerEnd += 360
            }
            withAnimation(.easeInOut(duration: 0.6).delay(1.3).repeatForever(autoreverses: false)) {
                spinnerStart +=  360
            }
        }
    }
    
    func animateSpinner() {
        animateSpinner(start: rotationTime) {
            self.spinnerEnd += 360
        }
        animateSpinner(start: rotationTime * 2) {
            self.spinnerStart += 360
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+animationTime) {
            resetSegmentLength()
        }
    }
    
    func animateSpinner(start: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: start, repeats: false) { (mainTimer) in
            withAnimation(Animation.easeOut(duration: animationTime - start)) {
                completion()
            }
        }
    }
}

private struct SpinnerCircle: Shape {
    var start: Double
    var end: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startAngle = Angle(degrees: start.remainder(dividingBy: 360))
        let endAngle = Angle(degrees: end.remainder(dividingBy: 360))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width/2, rect.height/2), startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(start, end)}
        set {
            start = newValue.first
            end = newValue.second
        }
    }
}

extension View {
    func loadingOverlay(_ isPresented: Binding<Bool>) -> some View {
        LoadingOverlay(isPresented: isPresented) {
            self
        }
    }
}
