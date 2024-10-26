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

class User {
    let name, userId: String
    var lastQuestionId: String?

    init (name: String, userId: String) {
        self.name = name
        self.userId = userId
    }
}