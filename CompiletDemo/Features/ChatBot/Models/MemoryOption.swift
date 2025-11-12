//
//  MemoryOption.swift
//  CompiletDemo
//

import Foundation

// MARK: - Memory option model
enum MemoryOption: String, CaseIterable, Identifiable {
  case none = "No memory"
  case messageWindow = "MessageWindow"
  
  var id: String { rawValue }
}
