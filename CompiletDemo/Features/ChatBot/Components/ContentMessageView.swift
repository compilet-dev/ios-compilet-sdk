//
//  ContentMessageView.swift
//  CompiletDemo
//

import SwiftUI

struct ContentMessageView: View {
  var text: String
  var attachments: [ChatAttachment]
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
      VStack(alignment: .leading, spacing: 8) {
        if !text.isEmpty {
          Text(text)
            .foregroundColor(.white)
        }
        
        if !attachments.isEmpty {
          VStack(alignment: .leading, spacing: 6) {
            ForEach(attachments) { att in
              attachmentRow(att)
            }
          }
        }
      }
      .padding(.horizontal, 14)
      .padding(.vertical, 10)
      .background(
        isCurrentUser
        ? LinearGradient(
          colors: [
            Color(red: 0.12, green: 0.53, blue: 0.90), Color(red: 0.26, green: 0.65, blue: 0.96),
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
        : LinearGradient(
          colors: [
            Color(red: 0.17, green: 0.17, blue: 0.18), Color(red: 0.17, green: 0.17, blue: 0.18),
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .cornerRadius(16)
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(
            isCurrentUser ? Color.clear : Color(red: 0.25, green: 0.25, blue: 0.26), lineWidth: 1)
      )
    }
  }
}

private extension ContentMessageView {
  @ViewBuilder
  func attachmentRow(_ attachment: ChatAttachment) -> some View {
    HStack(spacing: 8) {
      switch attachment {
      case .image(let url):
        ImagePreview(url: url)
      case .audio:
        Image(systemName: "waveform")
          .foregroundColor(.white)
        attachmentText(attachment)
      }
      Spacer(minLength: 0)
    }
  }
  
  func attachmentText(_ attachment: ChatAttachment) -> some View {
    Text(fileName(from: attachment))
      .font(.footnote)
      .foregroundColor(.white.opacity(0.9))
      .lineLimit(1)
  }
  
  func fileName(from attachment: ChatAttachment) -> String {
    switch attachment {
    case .image(let url), .audio(let url):
      //.video(let url),.pdf(let url):
      return url.lastPathComponent
    }
  }
}
