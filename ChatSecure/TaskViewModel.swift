import SwiftUI
import Firebase
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var listener: ListenerRegistration?

    private let db = Firestore.firestore()

    func fetchTasks() {
        guard let user = Auth.auth().currentUser else { return }

        let userRef = db.collection("employees").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                if let empID = userData?["empID"] as? String {
                    self.fetchTasksForEmpID(empID)
                } else {
                    print("Employee ID not found.")
                }
            } else {
                print("User document not found.")
            }
        }
    }

    func fetchTasksForEmpID(_ empID: String) {
        listener = db.collection("tasks")
            .whereField("assignedTo", isEqualTo: empID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error)")
                    return
                }
                
                var fetchedTasks: [Task] = []
                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let description = data["description"] as? String,
                       let assignedTo = data["assignedTo"] as? String,
                       let status = data["status"] as? String,
                       let dueDate = data["dueDate"] as? Timestamp,
                       let createdDate = data["createdDate"] as? Timestamp {
                        let task = Task(
                            id: document.documentID,
                            title: title,
                            description: description,
                            assignedTo: assignedTo,
                            status: status,
                            dueDate: dueDate.dateValue(),
                            createdDate: createdDate.dateValue()
                        )
                        fetchedTasks.append(task)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tasks = fetchedTasks
                }
            }
    }

    func fetchAllTasks() {
        listener = db.collection("tasks")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching all tasks: \(error)")
                    return
                }
                
                var fetchedTasks: [Task] = []
                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let description = data["description"] as? String,
                       let assignedTo = data["assignedTo"] as? String,
                       let status = data["status"] as? String,
                       let dueDate = data["dueDate"] as? Timestamp,
                       let createdDate = data["createdDate"] as? Timestamp,
                       let query = data["query"] as? String {
                        let task = Task(
                            id: document.documentID,
                            title: title,
                            description: description,
                            assignedTo: assignedTo,
                            status: status,
                            dueDate: dueDate.dateValue(),
                            createdDate: createdDate.dateValue(),
                            query: query
                        )
                        fetchedTasks.append(task)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tasks = fetchedTasks
                }
            }
    }

    func updateTaskStatus(task: Task, status: String) {
        db.collection("tasks").document(task.id).updateData([
            "status": status
        ]) { error in
            if let error = error {
                print("Error updating task status: \(error)")
            }
        }
    }
    
    func raiseQuery(for task: Task, query: String) {
        db.collection("tasks").document(task.id).updateData([
            "query": query
        ]) { error in
            if let error = error {
                print("Error raising query: \(error)")
            }
        }
    }

    func forwardTask(task: Task, newAssignee: String) {
        db.collection("tasks").document(task.id).updateData([
            "assignedTo": newAssignee
        ]) { error in
            if let error = error {
                print("Error forwarding task: \(error)")
            }
        }
    }
}
