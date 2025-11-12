//
//  ContentView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 15/09/2025.
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
          
          NavigationLink {
            AgentsListView()
          } label: {
            FeatureRowView(
              title: "Agents",
              subtitle: "Test agent features",
              icon: "person.fill"
            )
          }
          
          NavigationLink {
            Text("Feature C Screen")
              .font(.title)
              .bold()
          } label: {
            FeatureRowView(
              title: "Feature C",
              subtitle: "Placeholder for future features",
              icon: "gear"
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
