import SwiftUI
import CompiletSDK

struct ChatBotView: View {
  @StateObject private var viewModel = ChatBotViewModel()
  @State private var isShowChatCreationView: Bool = false
  
  var body: some View {
    contentView
      .padding()
      .navigationTitle("ChatBot")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            isShowChatCreationView = true
          }) {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(isPresented: $isShowChatCreationView) {
        SessionConfigAlertView { title, instruction, memory in
          viewModel.createChatSession(
            title: title,
            instruction: instruction,
            memory: memory
          )
        }
      }
  }

  var contentView: some View {
    VStack {
      if viewModel.chatSessions.isEmpty {
        Text("No chat sessions available.")
          .foregroundColor(.gray)
          .padding()
      } else {
        List {
          ForEach(viewModel.chatSessions) { session in
            NavigationLink(destination: DetailChatView(session: session)) {
              VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                  .font(.headline)
                Text(session.description)
                  .font(.caption)
                  .foregroundColor(.gray)
              }
              .padding(.vertical, 4)
            }
          }
        }
        .listStyle(PlainListStyle())
      }
    }
  }
}
