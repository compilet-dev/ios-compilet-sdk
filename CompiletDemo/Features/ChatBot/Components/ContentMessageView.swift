//
//  ContentMessageView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 18/09/2025.
//

import SwiftUI

struct ContentMessageView: View {
  var contentMessage: String
  var isCurrentUser: Bool
  var isTyping: Bool = false
  
  @State private var dotCount = 0
  private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
  
  var body: some View {
    if isTyping {
      HStack(spacing: 4) {
        ForEach(0..<3) { index in
          Circle()
            .fill(Color.white)
            .frame(width: 6, height: 6)
            .opacity(dotCount == index ? 1 : 0.3)
        }
      }
      .padding(12)
      .background(Color(red: 0.17, green: 0.17, blue: 0.18))
      .cornerRadius(16)
      .onReceive(timer) { _ in
        dotCount = (dotCount + 1) % 3
      }
    } else {
      Text(contentMessage)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(
          isCurrentUser
            ? LinearGradient(
                colors: [Color(red: 0.12, green: 0.53, blue: 0.90), Color(red: 0.26, green: 0.65, blue: 0.96)],
                startPoint: .leading,
                endPoint: .trailing
              )
            : LinearGradient(
                colors: [Color(red: 0.17, green: 0.17, blue: 0.18), Color(red: 0.17, green: 0.17, blue: 0.18)],
                startPoint: .leading,
                endPoint: .trailing
              )
        )
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(isCurrentUser ? Color.clear : Color(red: 0.25, green: 0.25, blue: 0.26), lineWidth: 1)
        )
    }
  }
}

