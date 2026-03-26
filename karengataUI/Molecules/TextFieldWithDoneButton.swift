import SwiftUI
import UIKit

struct TextFieldWithDoneButton: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldWithDoneButton

        init(_ parent: TextFieldWithDoneButton) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .numberPad
        //textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator

        // Add toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(textField.resignFirstResponder))
        doneButton.tintColor = UIColor(red: 23/255, green: 83/255, blue: 81/255, alpha: 1.0)
        toolbar.items = [.flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension UIBarButtonItem {
    static var flexibleSpace: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}
