import Foundation
import FoundationNetworking

final class Utils {

    static var users: [User] = [
        .init(name: "Steve", userId: "daoduyquang91"),
        .init(name: "Khoa", userId: "ldakhoa"),
        .init(name: "Duyệt", userId: "duyetnt"),
        .init(name: "Hải", userId: "trunghai95"),
        .init(name: "Thomas", userId: "qhcthanh"),
    ]

    static func sendMessageToTelegram(user: User, submission: Submission) {
        let urlString = "https://api.telegram.org/bot7844521804:AAH4YgbrKwSvf_y_2DiuvHimDT11Zmqd-Uo/sendMessage"
        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = [
            "chat_id": "-1002290807608",
            // "chat_id": "1887466101",
            "message_thread_id": "1400",
            "text": "\(user.name) just solved the problem: \(submission.title)",
            "disable_notification": true,
            "reply_markup": [
                "inline_keyboard": [
                [
                    ["text": "Open problem", "url": submission.questionUrl],
                    ["text": "See submission", "url": submission.submissionUrl],

                ]
            ]
        ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch(let error) {
            print(error)
        }

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in }

        task.resume()
    }   
}
