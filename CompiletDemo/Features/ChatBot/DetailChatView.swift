//
//  DetailChatView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 17/09/2025.
//

import SwiftUI
import Combine
import CompiletSDK

struct DetailChatView: View {
  @State var typingMessage: String = ""
  @StateObject var viewModel: DetailChatViewModel
  @State private var isLoadingHistory = true
  @State private var showModelPicker = false

  init(session: ChatSession) {
    UITableView.appearance().separatorStyle = .none
    UITableView.appearance().tableFooterView = UIView()
    self._viewModel = .init(wrappedValue: DetailChatViewModel(session: session))
  }
  
  var body: some View {
    ZStack {
      // Dark background
      Color(red: 0.11, green: 0.11, blue: 0.12)
        .ignoresSafeArea()

      VStack(spacing: 0) {
        if isLoadingHistory && viewModel.messages.isEmpty {
          // Loading state
          Spacer()
          ProgressView("Loading conversation history...")
            .progressViewStyle(CircularProgressViewStyle())
            .tint(.white)
            .foregroundColor(.white)
          Spacer()
          
        } else {
          // Messages view
          ScrollViewReader { proxy in
            ScrollView {
              LazyVStack(spacing: 12) {
                ForEach(viewModel.messages) { msg in
                  if !msg.content.isEmpty {
                    MessageView(currentMessage: msg)
                      .id(msg.id)
                  }
                }
                if viewModel.isAIResponding {
                  MessageView(currentMessage: Message(content: "", isCurrentUser: false), isTyping: true)
                    .padding(.top, 8)
                    .id("typing-indicator")
                }
              }
              .padding(.horizontal, 16)
              .padding(.top, 16)
              .padding(.bottom, 50)
              
              bottomMessageListLine
            }
            .onChange(of: viewModel.messages.count) { _ in
              if viewModel.messages.last != nil {
                scrollToBottom(proxy)
              }
            }
            .onChange(of: viewModel.isAIResponding) { isResponding in
              if isResponding {
                scrollToBottom(proxy)
              }
            }
            .onChange(of: viewModel.messages.last?.content) { message in
              guard message != nil else { return }
              // Auto-scroll during streaming when content updates
              scrollToBottom(proxy)
            }
            .onAppear {
              if viewModel.messages.last != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  scrollToBottom(proxy)
                }
              }
            }
          }
        }

        // Input area
        inputFieldView
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(viewModel.session.title)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .preferredColorScheme(.dark)
    .onTapGesture {
      self.endEditing(true)
    }
    .task {
      isLoadingHistory = false
    }
  }
  
  var bottomMessageListLine: some View {
    Rectangle()
      .fill(.clear)
      .frame(width: 1, height: 1)
      .id("bottomMessageListLine")
  }
  
  func scrollToBottom(_ proxy: ScrollViewProxy) {
    withAnimation(.easeInOut(duration: 0.2)) {
      proxy.scrollTo("bottomMessageListLine", anchor: .bottom)
    }
  }
}

// MARK: - Input Field
private extension DetailChatView {
  var inputFieldView: some View {
    VStack(spacing: 12) {
      modeSelectionView
      messageInputView
    }
    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
  }
  
  var messageInputView: some View {
    HStack(spacing: 12) {
      ZStack(alignment: .leading) {
        // Custom placeholder
        if typingMessage.isEmpty {
          Text("Message...")
            .foregroundColor(Color.gray.opacity(0.5))
            .padding(.leading, 16)
            .allowsHitTesting(false)
        }
        
        TextField("", text: $typingMessage)
          .textFieldStyle(PlainTextFieldStyle())
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
          .foregroundColor(.white)
          .tint(.blue)
          .disabled(isLoadingHistory)
      }
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color(red: 0.18, green: 0.18, blue: 0.19))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.white.opacity(0.1), lineWidth: 1)
      )
      
      sendButton
    }
    .padding(.horizontal, 16)
  }
  
  var sendButton: some View {
    Button(
      action: {
        Task {
          if viewModel.responseType == .streaming {
            viewModel.streamMessage(typingMessage) {
              typingMessage = ""
            }
          } else {
            await viewModel.sendMessage(typingMessage) {
              typingMessage = ""
            }
          }
        }
      },
      label: {
        Image(systemName: "arrow.up.circle.fill")
          .font(.system(size: 32))
          .foregroundColor(typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoadingHistory ? .gray : .blue)
      }
    )
    .disabled(typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoadingHistory)
  }
  
  var modeSelectionView: some View {
    Button(
      action: {
        viewModel.responseType = viewModel.responseType == .full ? ResponseMessageType.streaming : ResponseMessageType.full
      },
      label: {
        responseModeView(viewModel.responseType == .full ? .full : .streaming)
      }
    )
    .padding(.horizontal, 16)
  }
  
  func responseModeView(_ mode: ResponseMessageType) -> some View {
    HStack(spacing: 8) {
      Circle()
        .fill(mode.color)
        .frame(width: 8, height: 8)
      Text(mode.title)
        .font(.subheadline)
        .fontWeight(.medium)
      Spacer()
    }
    .foregroundColor(.white)
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color(red: 0.19, green: 0.19, blue: 0.20))
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(mode.color.opacity(0.4), lineWidth: 1)
        )
    )
  }
}
