import SwiftUI

struct BaseNavigationView<Content: View>: View
{
    let content: Content

    init(@ViewBuilder _ content: () -> Content)
    {
        self.content = content()
    }

    var body: some View
    {
        NavigationView
        {
            DefaultSurface
            {
                content
                    .navigationBarColor(backgroundColor: UIColor(Color.white))
            }
        }
    }
}
