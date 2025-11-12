//
//  SessionConfigAlertView.swift
//  CompiletDemo
//

import SwiftUI
import CompiletSDK

// MARK: - SessionConfigAlertView
struct SessionConfigAlertView: View {
  @Environment(\.dismiss) private var dismiss
  
  @State private var title: String = ""
  @State private var instruction: String = ""
  @State private var selectedMemory: MemoryOption = .none
  @State private var maxMessages: String = ""
  
  var onSave: (_ sessionName: String, _ instruction: String, _ memory: ChatMemory?) -> Void
  
  var body: some View {
    NavigationView {
      Form {
        // MARK: Session Name
        Section(header: Text("Chat Title").fontWeight(.semibold)) {
          TextField("Enter session name", text: $title)
            .autocapitalization(.none)
        }
        
        // MARK: Instruction
        Section(header: Text("Instruction").fontWeight(.semibold)) {
          ZStack(alignment: .topLeading) {
            if instruction.isEmpty {
              Text("Type system instruction for the assistant...\n(e.g. \"You are a friendly AI that speaks like a chill American buddy.\")")
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .font(.caption)
            }
            TextEditor(text: $instruction)
              .frame(minHeight: 120, maxHeight: 200)
              .padding(.horizontal, -4)
          }
        }
        
        // MARK: Memory Section
        Section(header: Text("Memory").fontWeight(.semibold)) {
          Picker("Select memory", selection: $selectedMemory) {
            ForEach(MemoryOption.allCases) { opt in
              Text(opt.rawValue).tag(opt)
            }
          }
          .pickerStyle(.menu)
          
          // Only show maxMessages input if MessageWindow selected
          if selectedMemory == .messageWindow {
            TextField("Max stored messages", text: $maxMessages)
              .keyboardType(.numberPad)
            Text("Set how many messages the assistant can remember.")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
      }
      .navigationTitle("Create Chat Session")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            let maxValue = Int(maxMessages) ?? 10
            let chatMemory = selectedMemory == .messageWindow ? MessageWindowChatMemory(id: "custom-memory", maxMessages: maxValue) : nil
            onSave(
              title.trimmingCharacters(in: .whitespacesAndNewlines),
              instruction.trimmingCharacters(in: .whitespacesAndNewlines),
              chatMemory
            )
            dismiss()
          }
          .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
      }
    }
  }
}
