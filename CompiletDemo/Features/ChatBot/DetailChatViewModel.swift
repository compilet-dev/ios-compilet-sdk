//
//  DetailChatViewModel.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 18/09/2025.
//

import SwiftUI
import CompiletSDK

@MainActor
final class DetailChatViewModel: ObservableObject {
  let session: ChatSession
  
  @Published var messages: [Message] = []
  @Published var isAIResponding = false
  @Published var responseType: ResponseMessageType = .streaming
  
  init(session: ChatSession) {
    self.session = session
  }
  
  func sendMessage(_ message: String, completion: @escaping () -> Void) async {
    messages.append(Message(content: message, isCurrentUser: true))
    completion()
    isAIResponding = true
    
    do {
      let response = try await session.chatShortcut.send(message)
      messages.append(Message(content: response.aiMessage.text ?? ""))
    } catch {
      messages.append(Message(content: "Error: \(error.localizedDescription)", isCurrentUser: false))
    }
    
    isAIResponding = false
  }
  
  func streamMessage(_ message: String, completion: (() -> Void)? = nil) {
    messages.append(Message(content: message, isCurrentUser: true))
    completion?()
    
    // Add placeholder AI message
    messages.append(Message(content: "", isCurrentUser: false))
    isAIResponding = true
    
    Task {
      do {
        let stream = try await session.chatShortcut.stream(message)
        
        for try await response in stream {
          guard let lastIndex = messages.indices.last,
                let text = response.message else { continue }
          
          switch response {
          case .partialResponse:
            messages[lastIndex].content += text
          case .completeResponse:
            messages[lastIndex].content = text
          default:
            break
          }
        }
      } catch {
        if let lastIndex = messages.indices.last {
          messages[lastIndex].content = "Unable to respond at the moment: \(error.localizedDescription)"
        }
      }
      
      isAIResponding = false
    }
  }
}
