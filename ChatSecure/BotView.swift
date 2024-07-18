import SwiftUI

struct BotView: View {
    @State private var messageText: String = ""
    @State private var messages: [String] = []
    private let botService = BotService()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Message List
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(messages, id: \.self) { message in
                            Text(message)
                                .padding()
                                .background(message.starts(with: "You:") ? Color.white : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                        }
                    }
                }
                
                // Input Field and Send Button
                HStack {
                    TextField("Enter message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)
                    
                    Button(action: sendMessage) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("Bot")
        .onAppear(perform: startConversation)
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
