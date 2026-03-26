import SwiftUI

extension View {
    func navigationBar() -> some View {
        self.navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
    func navigationBarBack(title: String) -> some View {
        self.navigationBar(title: title)
            .navigationBarItems(leading: NavigationBackButton() )
    }
    
    func navigationBarBack(canDismiss: Bool = true) -> some View {
        self.navigationBar()
            .navigationBarItems(leading: canDismiss ? NavigationBackButton(): nil)
    }
    
    func navigationBar(title: String) -> some View {
        self.navigationBar()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color.black)
                }
            }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
