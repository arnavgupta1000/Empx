import SwiftUI
import Firebase

struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var messageText: String = ""
    @State private var navigateToWelcome = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(chatViewModel.messages) { message in
                                ChatRowView(message: message)
                            }
                        }
                        .padding()
                    }

                    HStack {
                        TextField("Enter message...", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: CGFloat(30))

                        Button(action: {
                            if !messageText.isEmpty {
                                chatViewModel.sendMessage(text: messageText)
                                messageText = ""
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding()
                        }
                    }
                    .padding()
                }
                .navigationTitle("Chat")
                .navigationBarItems(trailing: Button("Log Out") {
                    do {
                        try Auth.auth().signOut()
                        navigateToWelcome = true
                    } catch let signOutError as NSError {
                        print("Error signing out: \(signOutError)")
                        // Optionally, show an alert to the user here
                    }
                })
                .onAppear {
                    chatViewModel.fetchInitialMessages()
                }
                
                // Navigation link to WelcomeView
                NavigationLink(destination: WelcomeView(isLoggedIn: $navigateToWelcome), isActive: $navigateToWelcome) {
                    EmptyView()
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
