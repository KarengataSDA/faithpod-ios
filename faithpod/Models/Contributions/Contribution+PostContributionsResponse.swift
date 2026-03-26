import Foundation

extension Contribution {
    init(response: PostContributionsResponse) {
        contributions = response.contributions?.map { ContributionItem(response: $0) }
    }
}

extension ContributionItem {
    init(response: ContributionResponse) {
        self.userId = response.user_id
        self.contributionTypeId = response.contributiontype_id
        self.contributionAmount = response.contribution_amount
        self.contributionDate = response.contribution_date
        self.status = response.status
    }
}
