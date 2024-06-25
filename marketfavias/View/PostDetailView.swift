import SwiftUI

struct PostDetailView: View {
    var post: PostModel

    var body: some View {
        VStack {
            if let imageUrl = post.postImage, let url = URL(string: imageUrl.absoluteString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .foregroundColor(.gray)
            }

            Text(post.title)
                .font(.largeTitle)
                .padding(.top, 8)

            Text(post.content)
                .font(.body)
                .padding(.top, 4)

            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(post.title), displayMode: .inline)
    }
}
