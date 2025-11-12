//
//  Message.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 03/11/2025.
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
