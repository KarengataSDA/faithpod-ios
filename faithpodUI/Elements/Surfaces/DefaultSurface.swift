
import SwiftUI

struct DefaultSurface<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
           // .background(Color.gray)
            
    }
}
