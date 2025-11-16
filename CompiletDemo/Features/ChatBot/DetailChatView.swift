import Combine
import CompiletSDK
import PhotosUI
import SwiftUI

struct DetailChatView: View {
  @State var typingMessage: String = ""
  @StateObject var viewModel: DetailChatViewModel
  @State private var isLoadingHistory = true
  
  // Attachments
  @State private var pendingAttachments: [ChatAttachment] = []
  @State private var showPhotosPicker = false
  @State private var showDocumentPicker = false
  @State private var photoSelections: [PhotosPickerItem] = []
  
  init(session: ChatSession) {
    UITableView.appearance().separatorStyle = .none
    UITableView.appearance().tableFooterView = UIView()
    self._viewModel = .init(wrappedValue: DetailChatViewModel(session: session))
  }
  
  var body: some View {
    ZStack {
      Color(red: 0.11, green: 0.11, blue: 0.12).ignoresSafeArea()
      
      VStack(spacing: 0) {
        messagesListView
        inputAreaView
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(viewModel.session.title)
    .onTapGesture { endEditing(true) }
    .task { isLoadingHistory = false }
  }
}

// MARK: - View Components
private extension DetailChatView {
  var messagesListView: some View {
    Group {
      if isLoadingHistory && viewModel.messages.isEmpty {
        Spacer()
        ProgressView("Loading conversation history...")
          .progressViewStyle(CircularProgressViewStyle())
          .tint(.white)
          .foregroundColor(.white)
        Spacer()
      } else {
        ScrollViewReader { proxy in
          ScrollView {
            LazyVStack(spacing: 12) {
              ForEach(viewModel.messages) { msg in
                if !msg.text.isEmpty || !msg.attachments.isEmpty {
                  MessageView(currentMessage: msg).id(msg.id)
                }
              }
              if viewModel.isAIResponding {
                MessageView(currentMessage: Message(text: "", isCurrentUser: false), isTyping: true)
                  .padding(.top, 8)
                  .id("typing-indicator")
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 50)
            bottomLine
          }
          .onChange(of: viewModel.messages.count) { _ in scrollToBottom(proxy) }
          .onChange(of: viewModel.isAIResponding) { isResponding in
            if isResponding { scrollToBottom(proxy) }
          }
          .onChange(of: viewModel.messages.last?.text) { _ in scrollToBottom(proxy) }
          .onAppear { scrollToBottom(proxy, delay: 0.1) }
        }
      }
    }
  }
  
  var bottomLine: some View {
    Rectangle().fill(.clear).frame(width: 1, height: 1).id("bottomMessageListLine")
  }
  
  func scrollToBottom(_ proxy: ScrollViewProxy, delay: Double = 0) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      withAnimation(.easeInOut(duration: 0.2)) {
        proxy.scrollTo("bottomMessageListLine", anchor: .bottom)
      }
    }
  }
  var inputAreaView: some View {
    VStack(spacing: 12) {
      modeSelectionView
      if !pendingAttachments.isEmpty { attachmentPreviewBar }
      messageInputView
    }
    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
  }
  
  var modeSelectionView: some View {
    Button {
      viewModel.responseType = (viewModel.responseType == .full) ? .streaming : .full
    } label: {
      responseModeView(viewModel.responseType == .full ? .full : .streaming)
    }
    .padding(.horizontal, 16)
  }
  
  func responseModeView(_ mode: ResponseMessageType) -> some View {
    HStack(spacing: 8) {
      Circle().fill(mode.color).frame(width: 8, height: 8)
      Text(mode.title).font(.subheadline).fontWeight(.medium)
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
  
  var messageInputView: some View {
    HStack(spacing: 12) {
      attachmentButtons
      ZStack(alignment: .leading) {
        if typingMessage.isEmpty {
          Text("Message...")
            .foregroundColor(.gray.opacity(0.5))
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
      .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.18, green: 0.18, blue: 0.19)))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
      sendButton
    }
    .padding(.horizontal, 16)
    .photosPicker(
      isPresented: $showPhotosPicker, selection: $photoSelections, maxSelectionCount: 5,
      matching: .images
    )
    .sheet(isPresented: $showDocumentPicker) {
      DocumentPickerView(isPresented: $showDocumentPicker) { urls in
        for url in urls {
          pendingAttachments.append(.audio(url: url))
        }
      }
    }
    .onChange(of: photoSelections) { newItems in
      Task {
        for item in newItems {
          if let data = try? await item.loadTransferable(type: Data.self),
             let uniformType = item.supportedContentTypes.first
          {
            let tempURL = writeTempFile(data: data, ext: uniformType.preferredFilenameExtension ?? "bin")
            if uniformType.conforms(to: .image) {
              pendingAttachments.append(.image(url: tempURL))
            }
          }
        }
        photoSelections.removeAll()
      }
    }
  }
  
  var attachmentButtons: some View {
    HStack(spacing: 12) {
      Button { showPhotosPicker = true } label: {
        Image(systemName: "photo.fill").font(.system(size: 24)).foregroundColor(.blue)
      }
      Button { showDocumentPicker = true } label: {
        Image(systemName: "paperclip.circle.fill").font(.system(size: 24)).foregroundColor(.blue)
      }
    }
    .disabled(isLoadingHistory)
  }
  
  var sendButton: some View {
    Button {
      Task { await handleSend() }
    } label: {
      Image(systemName: "arrow.up.circle.fill")
        .font(.system(size: 32))
        .foregroundColor(canSend ? .blue : .gray)
    }
    .disabled(!canSend)
  }
  
  var attachmentPreviewBar: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(Array(pendingAttachments.enumerated()), id: \.offset) { index, att in
          HStack(spacing: 6) {
            attachmentIcon(att)
            Text(previewName(att)).foregroundColor(.white).font(.footnote).lineLimit(1)
            Button { pendingAttachments.remove(at: index) } label: {
              Image(systemName: "xmark.circle.fill").foregroundColor(.white.opacity(0.7))
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 10)
          .background(Color(red: 0.18, green: 0.18, blue: 0.19))
          .cornerRadius(10)
          .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
      }
      .padding(.horizontal, 16)
    }
  }
  
  func attachmentIcon(_ att: ChatAttachment) -> some View {
    switch att {
    case .image: return Image(systemName: "photo").foregroundColor(.white)
    case .audio: return Image(systemName: "waveform").foregroundColor(.white)
    }
  }
}

// MARK: - Helper Functions
private extension DetailChatView {
  func handleSend() async {
    let trimmed = typingMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    var contents: [CompiletSDK.Message] = []
    let displayAttachments = pendingAttachments
    
    for att in pendingAttachments {
      guard let data = att.data else { return }
      switch att {
      case .image: contents.append(.imageData(data, mimeType: att.mimeType))
      case .audio: contents.append(.audioBase64(data.base64EncodedString(), mimeType: att.mimeType))
      }
    }
    
    if !trimmed.isEmpty { contents.append(.text(trimmed)) }
    guard !contents.isEmpty else { return }
    
    let resetInput = { typingMessage = ""; pendingAttachments.removeAll() }
    
    if viewModel.responseType == .streaming {
      viewModel.stream(contents: contents, displayText: trimmed, attachments: displayAttachments) { resetInput() }
    } else {
      await viewModel.send(contents: contents, displayText: trimmed, attachments: displayAttachments) { resetInput() }
    }
  }
  
  func writeTempFile(data: Data, ext: String) -> URL {
    let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
    try? data.write(to: tmp)
    return tmp
  }
  
  var canSend: Bool {
    (!typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !pendingAttachments.isEmpty) && !isLoadingHistory
  }
  
  func previewName(_ attachment: ChatAttachment) -> String {
    switch attachment {
    case .image(let url), .audio(let url):
      return url.lastPathComponent
    }
  }
}
