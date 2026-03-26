import Foundation

protocol HTTPEndpoint {
    var base: String { get }
    var location: String { get }
}

extension HTTPEndpoint {
    var endpoint: String {
        return "\(base)\(location)"
    }
}

enum FaithpodEndpoint: HTTPEndpoint {
    case customers_signin
    case customers_me
    case customers_update
    case contributions_type
    case make_contributions
    case transaction_status
    case get_user_contributions
    case get_announcements
    case password_email
    case groups
    case prayercells
    case hymns
    case hymnLanguages
    case hymnFavorites
    case toggleHymnFavorite(hymnId: Int)
    case token_refresh

    var base: String {
        return "/api"
    }

    var location: String {
        switch self {
        case .customers_signin:
            return "/members/login"

        case .customers_me:
            return "/members/me"

        case .customers_update:
            return "/members/update-info"

        case .contributions_type:
            return "/contribution-types"

        case .make_contributions:
            return "/add-mpesa-contributions"

        case .transaction_status:
            return "/transactions"

        case .get_user_contributions:
            return "/user-contributions"

        case .get_announcements:
            return "/announcements"

        case .password_email:
            return "/password/email"

        case .groups:
            return "/groups"

        case .prayercells:
            return "/prayercells"

        case .hymns:
            return "/hymns"

        case .hymnLanguages:
            return "/hymn-languages"

        case .hymnFavorites:
            return "/hymn-favorites"

        case .toggleHymnFavorite(let hymnId):
            return "/hymn-favorites/\(hymnId)/toggle"

        case .token_refresh:
            return "/refresh"
        }
    }
}
