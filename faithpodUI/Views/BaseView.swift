
import SwiftUI

struct BaseView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        DefaultSurface {
            content
        }
    }
}

