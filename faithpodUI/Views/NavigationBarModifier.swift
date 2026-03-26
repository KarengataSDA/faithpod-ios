import SwiftUI

struct NavigationBarModifier: ViewModifier
{
    init(backgroundColor: UIColor?)
    {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View
    {
        content
    }
}

extension View
{
    func navigationBarColor(backgroundColor: UIColor?) -> some View
    {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

