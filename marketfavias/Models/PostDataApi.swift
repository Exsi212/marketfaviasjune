import Foundation

class PostDataApi {
    func getPosts(completion: @escaping ([PostModel]) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:3000/api/v1/posts") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching posts:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // Настройка декодера для даты, если API возвращает даты в нестандартном формате
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // формат для апишки
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let posts = try decoder.decode([PostModel].self, from: data)
                DispatchQueue.main.async {
                    completion(posts)
                }
                print("Decoded posts: \(posts)")
            } catch {
                print("Failed to decode posts:", error.localizedDescription)
            }
        }.resume()
    }
}
