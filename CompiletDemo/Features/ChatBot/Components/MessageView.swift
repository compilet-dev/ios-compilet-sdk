//
//  MessageView.swift
//  CompiletDemo
//

import SwiftUI

struct MessageView: View {
  var currentMessage: Message
  var isTyping: Bool = false
  
  @ViewBuilder
  private var content: some View {
    ContentMessageView(
      text: currentMessage.text,
      attachments: currentMessage.attachments,
      isCurrentUser: currentMessage.isCurrentUser,
      isTyping: isTyping
    )
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 15) {
      if currentMessage.isCurrentUser {
        Spacer()
      }
      content
      if !currentMessage.isCurrentUser {
        Spacer()
      }
    }
  }
}
