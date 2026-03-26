import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        
        return alert(localizedAlertError?.failureReason ?? "Error",
                     isPresented: .constant(localizedAlertError != nil),
                     presenting: localizedAlertError) {
            _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Please try again.")
        }
    }
}
