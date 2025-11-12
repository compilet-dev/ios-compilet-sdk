//
//  CompiletDemoApp.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 15/09/2025.
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
    }
  }
}
