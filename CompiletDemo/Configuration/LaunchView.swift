//
//  LaunchView.swift
//  CompiletDemo
//

import SwiftUI

struct LaunchView: View {
  @Binding private var isShowLaunchView: Bool
  
  init(isShowLaunchView: Binding<Bool>) {
    _isShowLaunchView = isShowLaunchView
  }
  
  // MARK: - Body
  var body: some View {
    VStack {
      Spacer()
      Text("Compilet Demo App")
        .font(.headline)
        .bold()
        .foregroundStyle(.black)
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .background(Color.white)
    .task {
      try? await Task.sleep(nanoseconds: 2_000_000_000)
      isShowLaunchView = false
    }
  }
}
