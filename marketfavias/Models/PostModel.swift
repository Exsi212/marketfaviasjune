import Foundation

struct PostModel: Codable, Identifiable {
    var id: Int
    var name: String
    var title: String
    var content: String
    var createdAt: String
    var updatedAt: String
    var url: URL?  // URL for the post
    var postImage: URL?  // URL for the post image, add this if it is missing
    var likeInfo: LikeInfo?

    enum CodingKeys: String, CodingKey {
        case id, name, title, content, url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case likeInfo = "like_info"
        case postImage = "post_image"  // Make sure this matches the JSON key
    }

    struct LikeInfo: Codable {
        var liked: Bool
        var likeCount: Int

        enum CodingKeys: String, CodingKey {
            case liked
            case likeCount = "like_count"
        }
    }
}
