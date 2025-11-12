//
//  CompiletDemoApp.swift
//  CompiletDemo
//

import SwiftUI
import CompiletSDK

let projectId: String = "PROJECT_ID_HERE"
let apiKey: String = "API_KEY_HERE"

@main
struct CompiletDemoApp: App {
  init() {
    // Configure Compilet SDK
    Compilet.shared
      .configure(
        projectID: projectId,
        apiKey: apiKey,
        enableLogging: true
      )
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .toolbarColorScheme(.dark, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
  }
}
