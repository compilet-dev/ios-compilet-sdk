//
//  DetailChatViewModel.swift
//  CompiletDemo
//

import CompiletSDK
import SwiftUI

@MainActor
final class DetailChatViewModel: ObservableObject {
  let session: ChatSession
  
  @Published var messages: [Message] = []
  @Published var isAIResponding = false
  @Published var responseType: ResponseMessageType = .streaming
  
  init(session: ChatSession) {
    self.session = session
  }
}

// MARK: - Public functions
extension DetailChatViewModel {
  func send(
    contents: [CompiletSDK.Message], displayText: String, attachments: [ChatAttachment],
    completion: @escaping () -> Void
  ) async {
    messages.append(Message(text: displayText, attachments: attachments, isCurrentUser: true))
    completion()
    isAIResponding = true
    
    do {
      let response = try await session.chatShortcut.send(contents)
      messages.append(
        Message(text: response.aiMessage.text ?? "", attachments: [], isCurrentUser: false))
    } catch {
      messages.append(
        Message(text: "Unable to respond at the moment: \(getErrorMessage(error))", attachments: [], isCurrentUser: false)
      )
    }
    
    isAIResponding = false
  }
  
  func stream(
    contents: [CompiletSDK.Message], displayText: String, attachments: [ChatAttachment],
    completion: (() -> Void)? = nil
  ) {
    messages.append(Message(text: displayText, attachments: attachments, isCurrentUser: true))
    completion?()
    
    messages.append(Message(text: "", attachments: [], isCurrentUser: false))
    isAIResponding = true
    
    Task {
      do {
        let stream = try await session.chatShortcut.stream(contents)
        for try await response in stream {
          guard let lastIndex = messages.indices.last,
                let text = response.message
          else { continue }
          
          switch response {
          case .partialResponse:
            messages[lastIndex].text += text
          case .completeResponse:
            messages[lastIndex].text = text
          default:
            break
          }
        }
      } catch {
        guard let lastIndex = messages.indices.last else {
          return
        }
        
        messages[lastIndex].text = "Unable to respond at the moment: \(getErrorMessage(error))"
      }
      
      isAIResponding = false
    }
  }
}

// MARK: - Private functions
extension DetailChatViewModel {
  func getErrorMessage(_ error: Error) -> String {
    guard let compiletError = error as? CompiletError else {
      return error.localizedDescription
    }
    
    return compiletError.errorDescription ?? compiletError.localizedDescription
  }
}
