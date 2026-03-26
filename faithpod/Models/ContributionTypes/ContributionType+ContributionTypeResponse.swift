import Foundation

extension ContributionType {
    init(response: ContributionTypeResponse) {
        self.id = response.id
        self.name = response.name
        self.description = response.description
        self.archived = response.archived
        
    }
}
