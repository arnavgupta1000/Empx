import Foundation
struct Task: Identifiable {
    var id: String
    var title: String
    var description: String
    var assignedTo: String
    var status: String
    var dueDate: Date
    var createdDate: Date
    var query: String? // New field for queries
    var forwardedTo: String? // New field for forwarding
}
