import SwiftUI
import Firebase

struct AdminTaskListView: View {
    @ObservedObject var taskViewModel = TaskViewModel()
    
    var body: some View {
        VStack {
            Text("All Tasks")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            List(taskViewModel.tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline)
                    
                    Text("Due: \(task.dueDate, style: .date)")
                        .font(.subheadline)
                    
                    Text("Status: \(task.status)")
                        .font(.subheadline)
                    
                    if let remarks = task.query {
                        Text("Employee Remarks: \(remarks)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    if task.status == "Closed" {
                        Button(action: {
                            deleteTask(task: task)
                        }) {
                            Text("Delete Task")
                                .foregroundColor(.red)
                        }
                        .padding(.top, 5)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                                   startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
        .onAppear {
            taskViewModel.fetchAllTasks()
        }
    }
    
    func deleteTask(task: Task) {
        let db = Firestore.firestore()
        db.collection("tasks").document(task.id).delete { error in
            if let error = error {
                print("Error deleting task: \(error)")
            } else {
                if let index = taskViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                    taskViewModel.tasks.remove(at: index)
                }
            }
        }
    }
}

struct AdminTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        AdminTaskListView()
    }
}
