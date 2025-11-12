//
//  AgentsListViewModel.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 22/10/2025.
//

import SwiftUI
import CompiletSDK

@MainActor
final class AgentsListViewModel: ObservableObject {
  init() {
    createWeatherAgent()
  }
}

// MARK: - Functions
extension AgentsListViewModel {
  func fetchAgents() async {
  }
  
  func createAgent() async {
  }
  
  func deleteAgent() async {
  }
}

// MARK: - Private functions
private extension AgentsListViewModel {
  func createWeatherAgent() {
  }
}
