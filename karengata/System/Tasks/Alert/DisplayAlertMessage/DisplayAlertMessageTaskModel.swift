struct DisplayAlertMessageTaskModel {
    let alertMessage: AlertMessage
    
    init(message: String, style: AlertStyle) {
        alertMessage = AlertMessage(message: message, style: style)
    }
}
