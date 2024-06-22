import SwiftUI

struct MainView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    @State private var selectedTab = "Рекомендации"
    @State private var posts: [PostModel] = []
    private let postApi = PostApi()
    
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    // Верхний бар
                    HStack {
                        Text("FAVIAS")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            // действие для кнопки уведомлений
                        }) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // действие для кнопки поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                        }
                    }
                    .padding([.leading, .trailing, .top])
                    
                    // Пользовательская панель вкладок
                    CustomTabPicker(selectedTab: $selectedTab)
                    
                    // Сетка для отображения постов
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            if selectedTab == "Рекомендации" {
                                ForEach(posts) { post in
                                    PostView(post: post)
                                }
                            } else {
                                Text("Твои подписки")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Домой")
                    .foregroundColor(.white)
            }
            
            NavigationView {
                Text("Вторая страница")
                    .foregroundColor(.white)
            }
            .tabItem {
                Image(systemName: "heart")
                Text("Избранное")
                    .foregroundColor(.white)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            postApi.getPosts { fetchedPosts in
                print("Загруженные посты: \(fetchedPosts)") // Вывод в консоль для проверки
                self.posts = fetchedPosts
            }
        }
    }
}

// Пользовательский компонент для панели вкладок
struct CustomTabPicker: View {
    @Binding var selectedTab: String
    let tabs = ["Рекомендации", "Твои подписки"]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(selectedTab == tab ? Color.black : Color.clear)
                    .foregroundColor(selectedTab == tab ? .white : .gray)
                    .cornerRadius(10)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .white : .clear)
                            .padding(.top, 30),
                        alignment: .bottom
                    )
                    .onTapGesture {
                        withAnimation {
                            self.selectedTab = tab
                        }
                    }
            }
        }
        .background(Color.clear)
    }
}

// Представление для отображения каждого поста
struct PostView: View {
    var post: PostModel

    var body: some View {
        VStack {
            AsyncImage(url: post.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200)
            .cornerRadius(10)
            .clipped()

            Text(post.title)
                .foregroundColor(.white)
        }
        .frame(width: (UIScreen.main.bounds.width / 2) - 15, height: 250)
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
