//
//  ChatBotViewModel.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 17/09/2025.
//

import SwiftUI
import CompiletSDK

@MainActor
final class ChatBotViewModel: ObservableObject {
  @Published var chatSessions: [ChatSession] = ChatSession.chatSessionsDemo
  
  // Create new chat
  func createChatSession(title: String, instruction: String, memory: ChatMemory? = nil) {
    let chatShortcut = Compilet.shared.chat {
      $0.session("Custom chat")
      $0.instructions(instruction)
      if let memory {
        $0.memory(memory)
      }
    }
    
    let chatSession = ChatSession(title: title, description: "Custom chat session", chatShortcut: chatShortcut)
    chatSessions.append(chatSession)
  }
}

// MARK: - Chat Session Model
struct ChatSession: Identifiable {
  let id: UUID = UUID()
  let title: String
  let description: String
  let chatShortcut: ChatShortcut
  
  static let chatSessionsDemo = [
    ChatSession(
      title: "Normal Chat",
      description: "Simple chat without system instruction or memory.",
      chatShortcut: Compilet.shared.chat {
        $0.session("normal chat session")
      }
    ),
    ChatSession(
      title: "Compilet Assistant",
      description: "Demonstrates how multiple system messages can shape the assistant’s personality, tone, and behavior.",
      chatShortcut: Compilet.shared.chat {
        $0.instructions(
          "You are Compilet Assistant, a friendly and professional AI assistant.",
          "Always prefix your responses with [Compilet Assistant]:",
          "Keep your answers concise, polite, and helpful. Use a calm and confident tone."
        )
        $0.session("Assistant personality demo")
      }
    ),
    ChatSession(
      title: "Chat with Memory",
      description: "Remembers your context across messages (default store: 20 messages). The assistant talks in a fun, casual American style.",
      chatShortcut: Compilet.shared.chat {
        $0.instructions(
          "You are a friendly AI that speaks like a chill American buddy.",
          "Use light humor, casual tone, and common U.S. slang when appropriate."
        )
        $0.session("Memory session")
        $0.memory(MessageWindowChatMemory(id: "test-id", maxMessages: 20))
      }
    )
  ]
}
