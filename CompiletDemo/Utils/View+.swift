//
//  View+.swift
//  CompiletDemo
//

import SwiftUI

extension View {
  func endEditing(_ force: Bool) {
    UIApplication.shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .forEach { $0.endEditing(force) }
  }
}
