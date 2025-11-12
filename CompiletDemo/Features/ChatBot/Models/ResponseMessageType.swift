//
//  ResponseMessageType.swift
//  CompiletDemo
//

import SwiftUI

enum ResponseMessageType {
  case full
  case streaming
  
  var title: String {
    switch self {
    case .full:
      return "Full Response"
    case .streaming:
      return "Streaming Response"
    }
  }
  
  var color: Color {
    switch self {
    case .full:
      return Color(red: 0.11, green: 0.68, blue: 0.56)
    case .streaming:
      return Color(red: 0.82, green: 0.52, blue: 0.38)
    }
  }
}
