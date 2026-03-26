struct AlertMessage: Equatable {
    static func == (lhs: AlertMessage, rhs: AlertMessage) -> Bool {
        return lhs.message == rhs.message && lhs.style == rhs.style
    }
    
    let message: String
    let style: AlertStyle
    let secondaryActionLabel: String = ""
    var dismissActionLabel: String = "CANCEL"
    var primaryActionLabel: String = "OKAY"
    var isPrimaryActionEnabled: Bool = false
    var isSecondaryActionEnabled: Bool = true
    var primaryAction: (() -> Void)? = nil
    var secondaryAction: (() -> Void)? = nil
    var dismissAction: (() -> Void)? = nil 
}
