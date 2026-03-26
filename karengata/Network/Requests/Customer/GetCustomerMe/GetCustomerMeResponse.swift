import Foundation

struct GetCustomerMeResponse: Decodable {
    let id: Int?
    let first_name: String?
    let middle_name: String?
    let last_name: String?
    let phone_number: String?
    let email: String?
    let date_of_birth: String?
    let gender: String?
    let prayercell: PrayerCellResponse?
    let population_group: PopulationGroupResponse?

    struct PrayerCellResponse: Decodable {
        let id: Int
        let name: String
    }

    struct PopulationGroupResponse: Decodable {
        let id: Int
        let name: String
    }
}
