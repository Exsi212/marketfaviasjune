import SwiftUI

struct PostView: View {
    let post: PostModel
    let postApi = PostApi() // Для добавления функции лайка
    
    @State private var liked: Bool
    @State private var likeCount: Int
    
    init(post: PostModel) {
        self.post = post
        self._liked = State(initialValue: post.likeInfo?.liked ?? false)
        self._likeCount = State(initialValue: post.likeInfo?.likeCount ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: PostDetailView(post: post)) {
                if let imageURL = post.postImage {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 150)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 150, height: 150)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            }
            
            Text(post.title)
                .font(.headline)
                .padding(.top, 5)
            
            Text(post.content)
                .padding(.top, 2)
            
            HStack {
                Button(action: {
                    toggleLike()
                }) {
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .foregroundColor(liked ? .red : .gray)
                }
                Text("\(likeCount)")
            }
            .padding(.top, 2)
        }
    }
    
    private func toggleLike() {
        postApi.toggleLike(postId: post.id) { success in
            if success {
                self.liked.toggle()
                self.likeCount += self.liked ? 1 : -1
            }
        }
    }
}
