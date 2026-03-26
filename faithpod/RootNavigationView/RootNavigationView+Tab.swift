import SwiftUI

extension RootNavigationView {
    enum Tab {
        case home
        case hymnal
        case contribution
        case account
    }
    
    struct TabItem: View {
        private let isSelected: Bool
        private let action: () -> Void
        private let title: String
        private let iconDefault: Image
        private let iconSelected: Image
        var tabIcon: String? = "selected"
        
        init(isSelected: Bool, title: String, icon: Image, iconSelected: Image, tabIcon: String? = nil,  action: @escaping () -> Void) {
            self.isSelected = isSelected
            self.action = action
            self.title = title
            self.iconDefault = icon
            self.iconSelected = iconSelected
            self.tabIcon = tabIcon
        }
        
        var body: some View {
            Button {
                action()
            } label: {
                VStack(alignment: .center) {
                    icon()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isSelected ? Color("Green") : .black)
                    Text(title)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(isSelected ? Color("Green") : .black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.vertical, 4)
        }
        
        private func icon() -> Image {
            isSelected ? iconSelected : iconDefault
        }
    }
}
