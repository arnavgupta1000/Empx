import SwiftUI
import Firebase

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
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
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.darkGray))
                            
                            TextField("", text: $email)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.all, 10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }

                        VStack(alignment: .leading) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.darkGray))
                            
                            SecureField("", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.all, 10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Button(action: loginPressed) {
                        Text("Login")
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
                    
                    NavigationLink(destination: HomeView(), isActive: $navigateToChat) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 20)
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
            }
        }
    }

    func loginPressed() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                navigateToChat = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
