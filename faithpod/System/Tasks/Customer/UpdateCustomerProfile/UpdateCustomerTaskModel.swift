import Foundation

struct UpdateCustomerTaskModel {
    let firstName: String?
    let middleName: String?
    let lastName: String?
    let phoneNumber: String?
    let dateOfBirth: String?
    let gender: String?
    let prayercellId: Int?
    let populationGroupId: Int?
}

extension PutCustomerRequest.Payload {
    init(taskModel: UpdateCustomerTaskModel) {
        self.first_name = taskModel.firstName
        self.middle_name = taskModel.middleName
        self.last_name = taskModel.lastName
        self.phone_number = taskModel.phoneNumber
        self.date_of_birth = taskModel.dateOfBirth
        self.gender = taskModel.gender
        self.prayercell_id = taskModel.prayercellId
        self.population_group_id = taskModel.populationGroupId
    }
}
