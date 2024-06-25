import Foundation

struct CommentModel: Codable, Identifiable {
    var id: Int
    var content: String
    var user: UserModel
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, content, user
        case createdAt = "created_at"
    }
}
