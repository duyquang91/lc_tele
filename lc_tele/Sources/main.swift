import Foundation

let queue = DispatchQueue(label: "com.example.cronjob")
let timer = DispatchSource.makeTimerSource(queue: queue)
timer.schedule(deadline: .now(), repeating: .seconds(60))

timer.setEventHandler {
    for user in Utils.users {
        Utils.fetchACSubmitssion(for: user.userId) { result in
            switch result {
            case .success(let response):
                if let submission = response.submission.first, let question = submission.questionDetail {
                    if let userQuestionId = user.lastQuestionId {
                        if userQuestionId != question.questionId {
                            user.lastQuestionId = question.questionId
                            Utils.sendMessageToTelegram(text: "\(user.name) just solved the problem \(question.questionId).\(question.title): \(question.link)")
                        }
                    } else {
                        user.lastQuestionId = question.questionId
                        print("Updated user: \(user)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

timer.resume()

RunLoop.main.run()
