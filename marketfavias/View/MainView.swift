import SwiftUI

struct MainView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    @State private var selectedTab = "Рекомендации"
    @State private var posts: [PostModel] = []
    @State private var showSearch = false
    @State private var showNotifications = false
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
                            showNotifications.toggle()
                        }) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $showNotifications) {
                            NotificationView()
                        }
                        
                        Button(action: {
                            showSearch.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $showSearch) {
                            PostSearchView(posts: $posts)
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
                                    VStack {
                                        NavigationLink(destination: PostDetailView(post: post)) {
                                            AsyncImage(url: post.postImage) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(height: 150)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(height: 150)
                                                        .clipped()
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .frame(width: 150, height: 150)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                        PostView(post: post)
                                    }
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

// Переименованный SearchView
struct PostSearchView: View {
    @Binding var posts: [PostModel]
    @State private var searchText = ""
    private let postApi = PostApi()

    var body: some View {
        VStack {
            TextField("Поиск", text: $searchText, onCommit: {
                postApi.searchPosts(query: searchText) { fetchedPosts in
                    print("Загруженные посты (поиск): \(fetchedPosts)") // Вывод в консоль для проверки
                    self.posts = fetchedPosts
                }
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)

            List(posts) { post in
                Text(post.title) // Выводим только заголовок для примера
            }
        }
        .navigationBarTitle("Поиск", displayMode: .inline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
