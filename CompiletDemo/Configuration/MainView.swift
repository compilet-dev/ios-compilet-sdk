//
//  ContentView.swift
//  CompiletDemo
//

import SwiftUI
import CompiletSDK

struct MainView: View {
  init() {}
  
  var body: some View {
    NavigationStack {
      if Compilet.shared.isConfigured {
        List {
          NavigationLink {
            ChatBotView()
          } label: {
            FeatureRowView(
              title: "Chat",
              subtitle: "Test chat feature",
              icon: "message"
            )
          }
        }
        .navigationTitle("Compilet Demo App")
      } else {
        VStack {
          Spacer()
          Text("Please configure Compilet SDK first.")
            .font(.headline)
            .bold()
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}
