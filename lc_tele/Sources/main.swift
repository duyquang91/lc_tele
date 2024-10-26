import Foundation

let queue = DispatchQueue(label: "com.example.cronjob")
let timer = DispatchSource.makeTimerSource(queue: queue)
timer.schedule(deadline: .now(), repeating: .seconds(60))

timer.setEventHandler {
    for user in Utils.users {
        fetchLatestACSubmission(username: user.userId) {
            switch $0 {
            case .success(let submission):
                if let lastSubmissionTitleSlug = user.lastSubmissionTitleSlug {
                        if lastSubmissionTitleSlug != submission.titleSlug {
                            user.lastSubmissionTitleSlug = submission.titleSlug
                            Utils.sendMessageToTelegram(user: user, submission: submission)
                        }
                    } else {
                        user.lastSubmissionTitleSlug = submission.titleSlug
                        print("Updated user: \(user)")
                    }
            case .failure(let error):
                print(error)
            }
        }
    }
}

timer.resume()


RunLoop.main.run()
