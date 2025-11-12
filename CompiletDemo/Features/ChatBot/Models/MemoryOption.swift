//
//  MemoryOption.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 03/11/2025.
//

import Foundation

// MARK: - Memory option model
enum MemoryOption: String, CaseIterable, Identifiable {
  case none = "No memory"
  case messageWindow = "MessageWindow"
  
  var id: String { rawValue }
}
