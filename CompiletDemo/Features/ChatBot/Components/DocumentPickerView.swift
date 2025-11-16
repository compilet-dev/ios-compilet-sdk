//
//  DocumentPickerView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 16/11/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  var onPicked: ([URL]) -> Void
  
  func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let types: [UTType] = [UTType.audio]
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
    picker.allowsMultipleSelection = true
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(isPresented: $isPresented, onPicked: onPicked)
  }
  
  final class Coordinator: NSObject, UIDocumentPickerDelegate {
    @Binding var isPresented: Bool
    let onPicked: ([URL]) -> Void
    
    init(isPresented: Binding<Bool>, onPicked: @escaping ([URL]) -> Void) {
      self._isPresented = isPresented
      self.onPicked = onPicked
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      isPresented = false
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      isPresented = false
      onPicked(urls)
    }
  }
}
