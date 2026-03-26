struct Announcement: Codable, Hashable, Equatable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let image: String
}
