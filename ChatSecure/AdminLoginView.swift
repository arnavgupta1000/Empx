import SwiftUI
import Firebase

struct AdminLoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var navigateToAdminPanel = false
    @State private var showEmployeeRegisterButton = false // Track if admin is logged in

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

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

                if showEmployeeRegisterButton {
                    NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                        Text("Employee Register")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("Admin Login")
        }
    }

    func loginPressed() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // Check if the logged-in user has the admin role
                checkUserRoleAndProceed()
            }
        }
    }

    func checkUserRoleAndProceed() {
        guard let user = Auth.auth().currentUser else { return }

        // Fetch user role from Firestore or your database
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
