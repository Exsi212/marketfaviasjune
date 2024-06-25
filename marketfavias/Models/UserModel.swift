import Foundation

struct UserModel: Codable, Identifiable {
    var id: Int
    var name: String
    var avatarUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id, name
        case avatarUrl = "avatar_url"
    }
}
