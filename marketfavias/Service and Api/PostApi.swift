import Foundation

class PostApi {
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Failed to convert data to JSON string.")
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
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
    
    func searchPosts(query: String, completion: @escaping ([PostModel]) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:3000/api/v1/posts?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Failed to convert data to JSON string.")
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
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

    func addComment(postId: Int, content: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:3000/api/v1/posts/\(postId)/comments") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["content": content]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error adding comment:", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Failed to convert data to JSON string.")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: Bool].self, from: data)
                DispatchQueue.main.async {
                    completion(response["success"] ?? false)
                }
            } catch {
                print("Failed to decode response:", error.localizedDescription)
                completion(false)
            }
        }.resume()
    }

    func toggleLike(postId: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:3000/api/v1/posts/\(postId)/toggle_like") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error toggling like:", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Failed to convert data to JSON string.")
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: Bool].self, from: data)
                DispatchQueue.main.async {
                    completion(response["success"] ?? false)
                }
            } catch {
                print("Failed to decode response:", error.localizedDescription)
                completion(false)
            }
        }.resume()
    }
}
