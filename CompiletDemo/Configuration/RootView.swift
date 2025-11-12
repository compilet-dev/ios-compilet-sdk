//
//  RootView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 15/09/2025.
//
import SwiftUI

struct RootView: View {
  @State private var isShowLaunchView = true

  init() {}
  
  var body: some View {
    contentView
  }
  
  @ViewBuilder
  var contentView: some View {
    if isShowLaunchView {
      LaunchView(isShowLaunchView: $isShowLaunchView)
    } else {
      MainView()
    }
  }
}
