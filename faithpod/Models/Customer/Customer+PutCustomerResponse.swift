import Foundation

extension Customer {
    init(response: PutCustomerResponse) {
        self.init(
            userId: response.id,
            firstName: response.first_name ?? "",
            middleName: response.middle_name ?? "",
            lastName: response.last_name ?? "",
            email: response.email ?? "",
            birthDate: response.date_of_birth ?? "",
            phoneNumber: response.phone_number ?? "",
            gender: response.gender ?? "",
            prayercellId: response.prayercell?.id,
            populationGroupId: response.population_group?.id
        )
    }
}
