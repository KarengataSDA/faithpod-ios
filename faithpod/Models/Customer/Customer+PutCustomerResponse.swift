import Foundation

extension Customer {
    init(response: PutCustomerResponse) {
        let member = response.member
        self.init(
            userId: member.id,
            firstName: member.first_name ?? "",
            middleName: member.middle_name ?? "",
            lastName: member.last_name ?? "",
            email: member.email ?? "",
            birthDate: member.date_of_birth ?? "",
            phoneNumber: member.phone_number ?? "",
            gender: member.gender ?? "",
            prayercellId: member.prayercell?.id,
            populationGroupId: member.population_group?.id
        )
    }
}
