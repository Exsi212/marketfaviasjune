import SwiftUI

struct SearchView: View {
    @Binding var posts: [PostModel]
    @State private var searchText: String = ""
    private let postApi = PostApi()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Поиск", text: $searchText, onCommit: {
                    postApi.searchPosts(query: searchText) { fetchedPosts in
                        print("Загруженные посты (поиск): \(fetchedPosts)") // Вывод в консоль для проверки
                        self.posts = fetchedPosts
                    }
                })
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding([.leading, .trailing, .top])
            
            List {
                ForEach(posts) { post in
                    Text(post.title)
                }
            }
        }
        .navigationBarTitle("История поиска", displayMode: .inline)
        .navigationBarItems(trailing: Button("Очистить все") {
            // Действие для очистки истории поиска
        })
    }
}
