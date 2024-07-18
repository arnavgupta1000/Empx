import Foundation
struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isUser: Bool
    var timestamp: Date
    var senderName: String
}
