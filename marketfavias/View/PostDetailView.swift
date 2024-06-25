import SwiftUI

struct PostDetailView: View {
    let post: PostModel
    @State private var isShareSheetShowing = false
    @State private var comments: [CommentModel] = []

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Картинка поста
                    if let imageURL = post.postImage {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }

                    // Заголовок и контент
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(post.content)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)

                    // Действия
                    HStack {
                        Button(action: {
                            // Действие по жалобе на пост
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.circle")
                                Text("Пожаловаться")
                            }
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                // Действие по лайку
                            }) {
                                Image(systemName: "heart")
                            }
                            Text("\(post.likeInfo?.likeCount ?? 0)")
                        }
                        .foregroundColor(.white)
                        
                        Button(action: {
                            isShareSheetShowing = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal)

                    // Комментарии
                    Text("Комментарии")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(comments) { comment in
                        HStack(alignment: .top) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(comment.user.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(comment.content)
                                    .foregroundColor(.white)
                                Text(comment.createdAt)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $isShareSheetShowing, content: {
            ActivityView(activityItems: [post.url ?? URL(string: "https://favi.as")!])
        })
        .onAppear {
            loadComments()
        }
    }

    private func loadComments() {
        // Mock comments data
        comments = [
            CommentModel(id: 1, content: "Great post!", user: UserModel(id: 1, name: "User1", avatarUrl: nil), createdAt: "2024-06-25T12:34:56Z"),
            CommentModel(id: 2, content: "Thanks for sharing!", user: UserModel(id: 2, name: "User2", avatarUrl: nil), createdAt: "2024-06-25T13:45:67Z")
        ]
    }
}

// UIViewControllerRepresentable для использования UIActivityViewController в SwiftUI
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
//доработать
