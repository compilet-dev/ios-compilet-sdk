//
//  Message.swift
//  CompiletDemo
//

import Foundation

struct Message: Identifiable, Equatable {
  let id: UUID
  var content: String
  var isCurrentUser: Bool = false
  
  init(content: String, isCurrentUser: Bool = false) {
    self.id = UUID()
    self.content = content
    self.isCurrentUser = isCurrentUser
  }
}
