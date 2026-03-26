import Foundation

struct PutCustomerPayload: Encodable {
    let first_name: String?
    let middle_name: String?
    let last_name: String?
    let phone_number: String?
    let date_of_birth: String?
    let gender: String?
    let prayercell_id: Int?
    let population_group_id: Int?
}
