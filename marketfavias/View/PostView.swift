import SwiftUI

struct PostView: View {
    let post: PostModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: PostDetailView(post: post)) {
                if let imageURL = post.postImage {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 150)  // Уменьшаем высоту изображения
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)  // Уменьшаем высоту изображения
                                .clipped()  // Обрезаем изображение по границам фрейма
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 150, height: 150)  // Уменьшаем размеры изображения
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 150, height: 150)  // Уменьшаем размеры изображения
                }
            }
            
            Text(post.title)
                .font(.headline)
                .padding(.top, 5)
                .onTapGesture {
                    // Добавляем действие нажатия на заголовок
                    NavigationLink(destination: PostDetailView(post: post)) {
                        EmptyView()
                    }
                    .hidden()
                }
            
            Text(post.content)
                .padding(.top, 2)
                .lineLimit(2)  // Ограничиваем количество строк для контента
            
            HStack {
                Image(systemName: "heart")
                Text("\(post.likeInfo?.likeCount ?? 0)")
            }
            .padding(.top, 2)
        }
    }
}
