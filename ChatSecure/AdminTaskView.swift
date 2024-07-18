import SwiftUI
import Firebase

struct AdminTaskView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var assignedTo: String = ""
    @State private var status: String = "Pending"
    @State private var dueDate: Date = Date()
    @State private var showAlert: Bool = false
    @State private var employees: [Employee] = [] // List of employees
    @State private var selectedEmployeeID: String = "" // Currently selected employee ID

    var body: some View {
        VStack {
            Text("Assign Task")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 50)
            
            VStack(alignment: .leading) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Assign to", selection: $selectedEmployeeID) {
                    ForEach(employees) { employee in
                        Text("\(employee.name) (\(employee.empID))")
                            .tag(employee.empID)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                    .padding()
            }
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding()

            Button(action: assignTask) {
                Text("Assign Task")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Task Assigned"), message: Text("The task has been successfully assigned."), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                                   startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchEmployees()
        }
        .navigationBarTitle("Assign Task", displayMode: .inline)
    }

    func fetchEmployees() {
        let db = Firestore.firestore()
        db.collection("employees").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching employees: \(error)")
                return
            }
            self.employees = snapshot?.documents.compactMap { document in
                let data = document.data()
                if let empID = data["empID"] as? String, let name = data["name"] as? String {
                    return Employee(id: document.documentID, empID: empID, name: name)
                }
                return nil
            } ?? []
        }
    }

    func assignTask() {
        guard !selectedEmployeeID.isEmpty else { return }
        let db = Firestore.firestore()
        db.collection("tasks").addDocument(data: [
            "title": title,
            "description": description,
            "assignedTo": selectedEmployeeID,
            "status": status,
            "dueDate": Timestamp(date: dueDate),
            "createdDate": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error assigning task: \(error)")
            } else {
                showAlert = true
                title = ""
                description = ""
                selectedEmployeeID = ""
            }
        }
    }
}

struct Employee: Identifiable {
    var id: String
    var empID: String
    var name: String
}

struct AdminTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AdminTaskView()
    }
}
