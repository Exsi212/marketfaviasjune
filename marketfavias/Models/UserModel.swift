import Foundation

struct UserModel: Codable, Identifiable {
    var id: Int
    var name: String
    var avatarUrl: URL?
}
