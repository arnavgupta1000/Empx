import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    private var listener: ListenerRegistration?

    private let db = Firestore.firestore()

    init() {
        fetchInitialMessages()
        setupSnapshotListener()
    }

    deinit {
        listener?.remove()
    }

    func fetchInitialMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }

                var fetchedMessages: [Message] = []

                for doc in querySnapshot?.documents ?? [] {
                    let data = doc.data()
                    if let messageText = data[K.FStore.bodyField] as? String,
                       let messageSender = data[K.FStore.senderField] as? String,
                       let timestamp = data[K.FStore.dateField] as? Timestamp {
                        let isUser = messageSender == Auth.auth().currentUser?.email
                        let newMessage = Message(text: messageText, isUser: isUser, timestamp: timestamp.dateValue())
                        fetchedMessages.append(newMessage)
                    }
                }

                DispatchQueue.main.async {
                    self.messages = fetchedMessages
                }
            }
    }

    func setupSnapshotListener() {
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        let data = change.document.data()
                        if let messageText = data[K.FStore.bodyField] as? String,
                           let messageSender = data[K.FStore.senderField] as? String,
                           let timestamp = data[K.FStore.dateField] as? Timestamp {
                            let isUser = messageSender == Auth.auth().currentUser?.email
                            let newMessage = Message(text: messageText, isUser: isUser, timestamp: timestamp.dateValue())

                            DispatchQueue.main.async {
                                self.messages.append(newMessage)
                            }
                        }
                    }
                }
            }
    }

    func sendMessage(text: String) {
        if let messageSender = Auth.auth().currentUser?.email,
           let userID = Auth.auth().currentUser?.uid {
            _ = Message(
                text: text,
                isUser: true,
                timestamp: Date()
            )

            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: text,
                K.FStore.dateField: Date(),
                K.FStore.userIDField: userID
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    // Message added to Firestore successfully
                }
            }
        }
    }
}
