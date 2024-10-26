import Foundation

class User: CustomDebugStringConvertible {
    let name, userId: String
    var lastSubmissionTitleSlug: String?

    var debugDescription: String {
        "name: \(name), userId: \(userId), lastSubmissionTitleSlug: \(lastSubmissionTitleSlug ?? "nil")"
    }

    init (name: String, userId: String) {
        self.name = name
        self.userId = userId
    }
}