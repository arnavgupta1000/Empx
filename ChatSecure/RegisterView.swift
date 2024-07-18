import SwiftUI
import Firebase

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var address: String = ""
    @State private var designation: String = ""
    @State private var salary: String = ""
    @State private var empID: String = ""
    @State private var errorMessage: String?
    @State private var navigateToChat = false
    @State private var offset: CGFloat = 0 // For handling keyboard offset

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer().frame(height: 50)
                    
                    Text("Employee Registration")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            CustomTextField(placeholder: "Name", text: $name)
                            CustomTextField(placeholder: "Age", text: $age, keyboardType: .numberPad)
                            CustomTextField(placeholder: "Address", text: $address)
                            CustomTextField(placeholder: "Designation", text: $designation)
                            CustomTextField(placeholder: "Salary", text: $salary, keyboardType: .numberPad)
                            CustomTextField(placeholder: "Employee ID", text: $empID)
                            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            SecureTextField(placeholder: "Password", text: $password)
                        }
                        .padding(.horizontal, 20)
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        Button(action: registerPressed) {
                            Text("Register")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(Color(UIColor.systemBlue))
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        NavigationLink(destination: ChatView(chatViewModel: ChatViewModel()), isActive: $navigateToChat) {
                            EmptyView()
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .padding(.horizontal, 20)
                }
                .offset(y: -offset)
                .animation(.easeOut(duration: 0.16))
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            self.offset = keyboardFrame.height / 2
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                        self.offset = 0
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                }
            }
        }
    }

    func registerPressed() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                saveEmployeeData()
            }
        }
    }

    func saveEmployeeData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("employees").document(userID).setData([
            "name": name,
            "age": age,
            "address": address,
            "designation": designation,
            "salary": salary,
            "empID": empID,
            "email": email
        ]) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                navigateToChat = true
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
            
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

struct SecureTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.darkGray))
            
            SecureField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.all, 10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isLoggedIn: .constant(false))
    }
}
