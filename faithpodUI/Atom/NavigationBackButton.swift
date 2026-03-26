import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var nestedNavigationAction:(() -> Void)? = nil
    
    var body: some View {
        Button {
            if let nestedNavigationAction = nestedNavigationAction {
                nestedNavigationAction()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.bold))
                .foregroundColor(Color("Green"))
                .frame(width: 15, height: 15)
        }
    }
}
