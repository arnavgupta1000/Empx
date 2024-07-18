import Foundation
import Alamofire

class BotService {
    private let directLineSecret = "axM_QP9P7ts.NB5tIJo51SI7pv-RpcGZZJzl1ywLVP1Tl1gYz1Wevbk"
    private let baseURL = "https://directline.botframework.com/v3/directline"
    private var conversationId: String?
    
    func startConversation(completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)/conversations"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(directLineSecret)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: ConversationResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.conversationId = data.conversationId
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func sendMessage(_ message: String, completion: @escaping (Bool) -> Void) {
        guard let conversationId = conversationId else { return }
        let url = "\(baseURL)/conversations/\(conversationId)/activities"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(directLineSecret)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "type": "message",
            "from": ["id": "user"],
            "text": message
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func receiveMessages(completion: @escaping ([String]) -> Void) {
        guard let conversationId = conversationId else { return }
        let url = "\(baseURL)/conversations/\(conversationId)/activities"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(directLineSecret)"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ActivitiesResponse.self) { response in
            switch response.result {
            case .success(let data):
                let messages = data.activities.compactMap { $0.text }
                completion(messages)
            case .failure:
                completion([])
            }
        }
    }
}
