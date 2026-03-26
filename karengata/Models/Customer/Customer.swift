struct Customer: Codable, Equatable {
    let userId: Int
    let firstName: String
    let middleName: String
    let lastName: String
    let email: String
    let birthDate: String
    let phoneNumber: String
    let gender: String
    let prayercellId: Int?
    let populationGroupId: Int?

    enum CodingKeys: String, CodingKey {
        case userId
        case firstName
        case middleName
        case lastName
        case email
        case birthDate
        case phoneNumber
        case gender
        case prayercellId
        case populationGroupId
    }

    init(userId: Int, firstName: String, middleName: String, lastName: String, email: String, birthDate: String, phoneNumber: String, gender: String, prayercellId: Int?, populationGroupId: Int?) {
        self.userId = userId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.email = email
        self.birthDate = birthDate
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.prayercellId = prayercellId
        self.populationGroupId = populationGroupId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        middleName = try container.decodeIfPresent(String.self, forKey: .middleName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate) ?? ""
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        prayercellId = try container.decodeIfPresent(Int.self, forKey: .prayercellId)
        populationGroupId = try container.decodeIfPresent(Int.self, forKey: .populationGroupId)
    }

    func fullName() -> String {
        return firstName + " " + lastName
    }
}

