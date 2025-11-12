//
//  RootView.swift
//  CompiletDemo
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
