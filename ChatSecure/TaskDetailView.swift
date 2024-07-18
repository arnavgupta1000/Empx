import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    var task: Task
    @State private var queryText: String = ""
    @State private var newAssignee: String = ""

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    Text("Created: \(task.createdDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    Text("Due: \(task.dueDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    Text(task.description)
                        .foregroundColor(.white)
                        .padding()

                    Text("Status: \(task.status)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    if let query = task.query {
                        Text("Query: \(query)")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }

                    // Raise Query Section
                    HStack {
                        TextField("Enter query", text: $queryText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                        Button("Raise Query") {
                            taskViewModel.raiseQuery(for: task, query: queryText)
                            queryText = ""
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    // Forward Task Section
                    HStack {
                        TextField("New Assignee", text: $newAssignee)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                        Button("Forward Task") {
                            taskViewModel.forwardTask(task: task, newAssignee: newAssignee)
                            newAssignee = ""
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    // Status Buttons
                    if task.status == "Pending" {
                        Button("Mark as In Progress") {
                            taskViewModel.updateTaskStatus(task: task, status: "In Progress")
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else if task.status == "In Progress" {
                        Button("Mark as Done") {
                            taskViewModel.updateTaskStatus(task: task, status: "Done")
                        }
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        Button("Mark as Closed") {
                            taskViewModel.updateTaskStatus(task: task, status: "Closed")
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Task Details", displayMode: .inline) // Ensure only one back button
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let task = Task(
            id: "1",
            title: "Sample Task",
            description: "This is a sample task description.",
            assignedTo: "Employee1",
            status: "Pending",
            dueDate: Date(),
            createdDate: Date(),
            query: "Sample query",
            forwardedTo: nil
        )
        return TaskDetailView(taskViewModel: TaskViewModel(), task: task)
    }
}
