import SwiftUI

struct ChatRowView: View {
    var message: Message

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading) {
            Text(message.senderName) // Display sender's name
                .font(.subheadline)
                .foregroundColor(message.isUser ? .blue : .gray)
                .padding(.horizontal, 10)
                .padding(.top, 5)
            
            HStack {
                if message.isUser {
                    Spacer()
                    Text(message.text)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                        .shadow(radius: 5)
                } else {
                    Text(message.text)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.leading, 10)
                        .shadow(radius: 5)
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .transition(.slide)
        }
    }
}

struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        let message = Message(text: "Hello!", isUser: false, timestamp: Date(), senderName: "User")
        return ChatRowView(message: message)
    }
}
