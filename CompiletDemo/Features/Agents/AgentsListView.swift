//
//  AgentsView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 22/10/2025.
//

import SwiftUI
import CompiletSDK

struct AgentsListView: View {
  @StateObject private var viewModel = AgentsListViewModel()
  @State private var showDeleteAlert = false
  @State private var responseType: ResponseMessageType = .streaming
  
  var body: some View {
    contentView
      .padding()
      .navigationTitle("Agents")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            Button(action: { responseType = .full }) {
              Label("Full Response", systemImage: responseType == .full ? "checkmark" : "")
            }
            Button(action: { responseType = .streaming }) {
              Label("Streaming Response", systemImage: responseType == .streaming ? "checkmark" : "")
            }
          } label: {
            Image(systemName: "ellipsis.circle")
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            Task {
              await viewModel.createAgent()
            }
          }) {
            Image(systemName: "plus")
          }
        }
      }
      .task {
        await viewModel.fetchAgents()
      }
//      .alert("Delete Agent",
//             isPresented: $showDeleteAlert,
//             presenting: agentToDelete) { agent in
//        Button("Delete", role: .destructive) {
//          Task {
//          }
//        }
//        Button("Cancel", role: .cancel) {}
//      } message: { agent in
//        Text("Are you sure you want to delete \"\(agent.agent.name)\"?")
//      }
  }
}

// MARK: - View Components
private extension AgentsListView {
  var contentView: some View {
    VStack {
      Text("No agent available.")
        .foregroundColor(.gray)
        .padding()
//      if viewModel.agents.isEmpty {
//        Text("No agent available.")
//          .foregroundColor(.gray)
//          .padding()
//      } else {
//        List {
//          ForEach(viewModel.agents) { agent in
//            NavigationLink(destination: EmptyView()) {
//              VStack(alignment: .leading, spacing: 4) {
//                Text(agent.agent.name)
//                  .font(.headline)
//                Text(agent.agent.model.name)
//                  .font(.caption)
//                  .foregroundColor(.gray)
//              }
//              .padding(.vertical, 4)
//              .task {
//              }
//            }
//          }
//          .onDelete { indexSet in
//            if let index = indexSet.first {
//              agentToDelete = viewModel.agents[index]
//              showDeleteAlert = true
//            }
//          }
//        }
//        .listStyle(PlainListStyle())
//      }
    }
  }
}
