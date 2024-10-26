import Foundation
import FoundationNetworking

struct GraphQLRequest: Codable {
    let query: String
    let variables: [String: String]
}

struct GraphQLResponse: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let recentAcSubmissionList: [Submission]
}

struct Submission: Codable {
    let id, title, titleSlug: String

    var questionUrl: String {
        "https://leetcode.com/problems/\(titleSlug)"
    }

    var submissionUrl: String {
        "https://leetcode.com/submissions/detail/\(id)"
    }
}

func fetchLatestACSubmission(username: String, completion: @escaping (Result<Submission, Error>) -> Void) {
    let url = URL(string: "https://leetcode.com/graphql")!
    let query = """
    query getLatestACSubmission($username: String!) {
      recentAcSubmissionList(username: $username, limit: 1) {
        id
        title
        titleSlug
      }
    }
    """
    let variables = ["username": username]
    let requestBody = GraphQLRequest(query: query, variables: variables)
    
    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        print("Error encoding JSON")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            let response = try JSONDecoder().decode(GraphQLResponse.self, from: data)
            if let latestSubmission = response.data.recentAcSubmissionList.first {
                completion(.success(latestSubmission))
            } else {
                print("No submissions found")
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}