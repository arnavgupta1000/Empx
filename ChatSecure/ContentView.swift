import SwiftUI
import Firebase

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            if isLoggedIn {
                ChatView()
            } else {
                WelcomeView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                self.isLoggedIn = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
