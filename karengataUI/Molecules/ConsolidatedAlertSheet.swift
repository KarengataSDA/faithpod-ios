import SwiftUI
import CoreGraphics

extension View
{
    func consolidatedAlertSheet() -> some View
    {
        ZStack(alignment: .top)
        {
            self
            ConsolidatedAlertSheet()
        }
    }
}

struct ConsolidatedAlertSheet: View, Identifiable
{
    @Environment(\.dependencies.tasks) var tasks
    @Environment(\.dependencies.state.alertState) var alertState
    
    @AccessibilityFocusState private var isFocused: Bool
    @State var id = UUID().uuidString
    @State private var isPresented: Bool = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var hasMultipleActions : Bool
    {
        return alertState.alertMessage?.style == .multipleActions
    }
    
    @GestureState private var viewOffset: CGFloat = 0.0
    
    var body: some View
    {
        ZStack(alignment: hasMultipleActions ? .center : .top)
        {
            if isPresented
            {
                if hasMultipleActions
                {
                    Color.black.opacity(0.33)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .zIndex(1)
                    
                }
                else
                {
                    bodyView()
                        .transition(.move(edge: .top))
                        .zIndex(2)
                }
                
            }
        }
        .opacity(isPresented ? 1 : 0)
        .onReceive(timer, perform: { _ in
            if !hasMultipleActions
            {
                dismiss()
            }
        })
        .onChange(of: isPresented) { newValue in
            isFocused = isPresented
            if !newValue
            {
                let task = tasks.initialize(ClearAlertsTask.self)
                task.execute()
            }
        }
        .onReceive(alertState.$alertMessage) { message in
            if message != nil
            {
                withAnimation
                {
                    isPresented = true
                }
            }
            else
            {
                isPresented = false
            }
        }
        .onAppear
        {
            isFocused = true
            isPresented = false
        }
    }
    
    private func bodyView() -> some View
    {
        Group
        {
            if let alertMessage = alertState.alertMessage
            {
                ConsolidatedAlertView(alertMessage: alertMessage)
                {
                    dismiss()
                }
                .accessibilityFocused($isFocused)
                .offset(x: 0, y: viewOffset)
            }
        }
    }
    
    private func dismiss()
    {
        withAnimation
        {
            isPresented = false
        }
    }
}
