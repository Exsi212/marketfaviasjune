import Foundation

class UserService {
    private let csrfToken: String
    private let session = URLSession.shared
    private let baseURL = "http://127.0.0.1:3000/api/v1"
    
    init(csrfToken: String) {
        self.csrfToken = csrfToken
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "session": [
                "email": email,
                "password": password
            ]
        ]
        
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(csrfToken, forHTTPHeaderField: "X-CSRF-Token")
        
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true, "Login successful")
            } else {
                let responseMessage = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
                let errorMessage = responseMessage?["error"] as? String ?? "Unknown error"
                completion(false, errorMessage)
            }
        }.resume()
    }
}
