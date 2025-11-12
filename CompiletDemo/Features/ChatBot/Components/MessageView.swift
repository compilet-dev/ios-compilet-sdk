//
//  MessageView.swift
//  CompiletDemo
//

import SwiftUI

struct MessageView : View {
  var currentMessage: Message
  var isTyping: Bool = false
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 15) {
      if currentMessage.isCurrentUser {
        Spacer()
      }
      ContentMessageView(
        contentMessage: currentMessage.content,
        isCurrentUser: currentMessage.isCurrentUser,
        isTyping: isTyping
      )
      if !currentMessage.isCurrentUser {
        Spacer()
      }
    }
  }
}
