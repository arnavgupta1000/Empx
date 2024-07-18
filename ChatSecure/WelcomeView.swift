import SwiftUI

struct WelcomeView: View {
    @Binding var isLoggedIn: Bool
    @State private var titleText: String = ""
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            LazyVStack(spacing: 20) {
                NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                    Text("Employee Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: AdminLoginView(isLoggedIn: $isLoggedIn)) {
                    Text("Admin Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear(perform: animateText)
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func animateText() {
        titleText = ""
        var charIndex = 0.0
        let titleString = K.appName
        for letter in titleString {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * charIndex) {
                titleText.append(letter)
            }
            charIndex += 1
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(isLoggedIn: .constant(false))
    }
}

