import SwiftUI

struct EmployeeTasksView: View {
    @ObservedObject var taskViewModel = TaskViewModel()
    @State private var selectedTask: Task?

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("My Tasks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    if taskViewModel.tasks.isEmpty {
                        Text("No tasks available")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        List(taskViewModel.tasks) { task in
                            NavigationLink(destination: TaskDetailView(taskViewModel: taskViewModel, task: task)) {
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Due: \(task.dueDate, style: .date)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("", displayMode: .inline) // Hide the default navigation bar title
            .onAppear {
                taskViewModel.fetchTasks() // Fetch tasks when the view appears
            }
        }
    }
}

struct EmployeeTasksView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeTasksView()
    }
}
