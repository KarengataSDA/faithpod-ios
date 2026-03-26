import Foundation

extension TransactionStatus {
    init(response: TransactionStatusResponse) {
        message = response.message
        status = response.status
    }
}
