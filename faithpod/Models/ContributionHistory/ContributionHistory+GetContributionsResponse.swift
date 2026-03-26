extension ContributionHistory {
    init(response: ContributionHistoryResponse) {
        self.id = response.id
        self.userId = response.user_id
        self.contributiontypeId = response.contributiontype_id
        self.contributionAmount = response.contribution_amount
        self.contributionDate = response.contribution_date
        self.status = response.status
        self.emailSent = response.email_sent
        self.smsSent = response.sms_sent
        self.contributionType = response.contribution_type
    }
}
