import SwiftUI
import Firebase

struct AdminLoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var navigateToAdminPanel = false
    @State private var showEmployeeRegisterButton = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Admin Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: loginPressed) {
                    Text("Login")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if navigateToAdminPanel {
                    NavigationLink(destination: AdminPanelView(isLoggedIn: $isLoggedIn)) {
                        Text("Go to Admin Panel")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                                       startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }

    func loginPressed() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                checkUserRoleAndProceed()
            }
        }
    }

    func checkUserRoleAndProceed() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("user").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                if let role = userData?["role"] as? String {
                    if role == "admin" {
                        navigateToAdminPanel = true
                        isLoggedIn = true
                        showEmployeeRegisterButton = true
                    } else {
                        errorMessage = "You do not have admin privileges."
                    }
                } else {
                    errorMessage = "User role not defined."
                }
            } else {
                errorMessage = "User not found."
            }
        }
    }
}

struct AdminLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdminLoginView(isLoggedIn: .constant(false))
    }
}
