import SwiftUI
import CoreGraphics

struct ConsolidatedAlertView: View {
    @Environment(\.dependencies.tasks) var tasks
    
    @AccessibilityFocusState private var isFocused: Bool
    let alertMessage: AlertMessage
    var onDismiss: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(alignment: .center, spacing: 16) {
                if let leftView = leftView() {
                    leftView
                        .frame(width: 14, height: 14)
                }
                Text(alertMessage.message)
                    .font(.system(size: 12))
                    .foregroundColor(textColor())
                    .multilineTextAlignment(.leading)
                    .accessibilitySortPriority(2)
                
                if let rightView = rightView() {
                    rightView
                        .frame(width: 14, height:14)
                }
            }
            .padding(10)
            .background(backgroundColor())
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor(), lineWidth: borderWidth())
            )
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if !isFocused {
                    isFocused = true
                }
            }
        }
    }
    
    private func dismiss() {
        isFocused = false
        onDismiss?()
    }
    
    private func leftView() -> AnyView? {
        switch alertMessage.style {
        case .success:
            return nil
            
        case .error:
            return AnyView(
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(Color.red))
            
        case .errorInline:
            return AnyView(
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(Color.red) )
            
        case .warning:
            return AnyView(
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(Color.red))
            
        default:
            return nil
        }
    }
    
    private func rightView() -> AnyView? {
        switch alertMessage.style {
        case .success:
            return AnyView(Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
            }))
        default:
            return nil
        }
    }
    
    private func textColor() -> Color {
        switch alertMessage.style {
        case .success:
            return Color("Green")
            
        case .error:
            return Color.red
            
        case .errorInline:
            return Color.red
            
        case .warning:
            return Color.orange
            
        default:
            return Color.black
        }
    }
    
    private func backgroundColor() -> Color {
        switch alertMessage.style {
        case .success:
            return Color.green.opacity(0.2)
        case .error:
            return Color.red.opacity(0.2)
        case .errorInline:
            return Color.red
        case .warning:
            return Color.orange
        default:
            return Color.black
        }
    }
    private func borderColor() -> Color {
        switch alertMessage.style {
        case .success:
            return Color("Green")
        case .error:
            return Color.red
        case .errorInline:
            return Color.red
        case .warning:
            return Color.orange
        default:
            return .clear
        }
    }
    
    private func borderWidth() -> CGFloat {
        switch alertMessage.style {
        case .success:
            return 1
        case .error:
            return 1
            
        default:
            return 0
        }
    }
}
