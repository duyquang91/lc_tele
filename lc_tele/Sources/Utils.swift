import Foundation

final class Utils {

    static var users: [User] = [
        .init(name: "Steve", userId: "daoduyquang91"),
        .init(name: "Khoa", userId: "ldakhoa"),
        .init(name: "Duyệt", userId: "duyetnt"),
        .init(name: "Hải", userId: "trunghai95"),
    ]
    
    static func fetchJSON<T: Codable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    static func fetchACSubmitssion(for user: String, completion: @escaping (Result<SubmitssionResponse, Error>) -> Void) {
        fetchJSON<SubmitssionResponse>(from: "https://alfa-leetcode-api.onrender.com/\(user)/acsubmission?limit=1") {
            switch $0 {
                case .success(let response):
                if let submittion = response.submission.first {
                    fetchACSubmitssion<QuestionModel>(for: "https://alfa-leetcode-api.onrender.com/select?titleSlug=\(submittion.titleSlug)") {
                        switch $0 {
                            case .success(let question):
                                submittion.questionDetail = question
                                completion(.success(response))
                            case .failure(let error):
                                completion(.failure(error))
                        }
                    }
                }
                case .failure(let error):
                    break
            }
        }
    }

    static func sendMessageToTelegram(text: String) {
        let urlString = "https://api.telegram.org/bot7844521804:AAH4YgbrKwSvf_y_2DiuvHimDT11Zmqd-Uo/sendMessage"
        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = [
            "chat_id": "-1002290807608",
            "message_thread_id": "1400",
            "text": text,
            "disable_notification": true
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } 

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in }

        task.resume()
    }   
}
