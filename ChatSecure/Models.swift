import Foundation

struct ConversationResponse: Decodable {
    let conversationId: String
}

struct Activity: Decodable {
    let text: String?
}

struct ActivitiesResponse: Decodable {
    let activities: [Activity]
}
