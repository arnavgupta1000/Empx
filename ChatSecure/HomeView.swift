import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Choose The Service")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: ChatView()) {
                        Text("Chat")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color(UIColor.systemBlue))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: BotView()) {
                        Text("Bot")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color(UIColor.systemBlue))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 50)
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
