import Foundation

struct ContributionsTaskModel {
    struct Item {
        let userId: Int?
        let contributionTypeId: Int?
        let contributionAmount: Double?
        let contributionDate: String?
        let status : String?
    }
   
    let contributions: [Item]
}

extension ContributionsRequest.Payload {
    init(taskModel: PostContributionsTask.Model) {
        contributions = taskModel.contributions.map { contribution in
            Item(contribution : contribution)
        }
    }
}


extension ContributionsRequest.Payload.Item {
    init(contribution: ContributionsTaskModel.Item) {
        self.user_id = contribution.userId
        self.contributiontype_id = contribution.contributionTypeId
        self.contribution_amount = contribution.contributionAmount
        self.contribution_date = contribution.contributionDate
        self.status = contribution.status
    }
}
