//
//  Message.swift
//  CompiletDemo
//

import Foundation

struct Message: Identifiable, Equatable {
  let id: UUID
  var text: String
  var attachments: [ChatAttachment]
  var isCurrentUser: Bool
  
  init(
    text: String,
    attachments: [ChatAttachment] = [],
    isCurrentUser: Bool = false
  ) {
    self.id = UUID()
    self.text = text
    self.attachments = attachments
    self.isCurrentUser = isCurrentUser
  }
}
