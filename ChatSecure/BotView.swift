import SwiftUI

struct BotView: View {
    @State private var messageText: String = ""
    @State private var messages: [String] = []
    private let botService = BotService()
    
    var body: some View {
        NavigationView {
            VStack {
                List(messages, id: \.self) { message in
                    Text(message)
                }
                
                HStack {
                    TextField("Enter message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: sendMessage) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Bot")
            .onAppear(perform: startConversation)
        }
    }
    
    private func startConversation() {
        botService.startConversation { success in
            if success {
                receiveMessages()
            }
        }
    }
    
    private func sendMessage() {
        let message = messageText
        messageText = ""
        messages.append("You: \(message)")
        
        botService.sendMessage(message) { success in
            if success {
                receiveMessages()
            }
        }
    }
    
    private func receiveMessages() {
        botService.receiveMessages { newMessages in
            messages.append(contentsOf: newMessages.filter { !$0.starts(with: "You:") })
        }
    }
}

struct BotView_Previews: PreviewProvider {
    static var previews: some View {
        BotView()
    }
}
