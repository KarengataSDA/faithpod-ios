import SwiftUI

struct HomeCarousel: View {
    let imagesName: [String] = ["image_1", "image_2", "image_3", "image_4", "image_5"]
    @State private var currentIndex  = 0
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<imagesName.count, id: \.self) { imageIndex in
                Image(imagesName[imageIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .clipped()
            }
        }
        
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
        .cornerRadius(10)
        .padding(.horizontal, 12)
        .onReceive(timer, perform: { _ in
            withAnimation {
                currentIndex = currentIndex < (imagesName.count - 1) ? (currentIndex + 1) : 0
            }})
    }
}

#Preview {
    HomeCarousel()
}
