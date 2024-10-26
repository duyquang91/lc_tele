import Foundation

struct SubmitssionResponse: Codable {
    let submission: [SubmitssionModel]
}

struct SubmitssionModel: Codable {
    let title, titleSlug: String
    let statusDisplay: StatusDisplay

    var questionDetail: QuestionModel?
}

enum StatusDisplay: String, Codable {
    case accepted = "Accepted"
}

struct QuestionModel: Codable {
    let link, questionId: String
}

class User: CustomDebugStringConvertible {
    let name, userId: String
    var lastQuestionId: String?

    var debugDescription: String {
        "name: \(name), userId: \(userId), lastQuestionId: \(lastQuestionId ?? "nil")"
    }

    init (name: String, userId: String) {
        self.name = name
        self.userId = userId
    }
}