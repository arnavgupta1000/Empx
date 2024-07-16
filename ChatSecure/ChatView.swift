import SwiftUI
import Firebase

struct ChatView: View {
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var messageText: String = ""

    var body: some View {
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
        .navigationBarItems(trailing: Button("Log Out") {
            do {
                try Auth.auth().signOut()
                // Navigate to WelcomeView
                // Assuming using NavigationLink to trigger the navigation in the parent view
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        })
        .onAppear {
            chatViewModel.fetchInitialMessages()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
