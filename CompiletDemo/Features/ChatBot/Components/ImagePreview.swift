//
//  ImagePreview.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 16/11/2025.
//

import SwiftUI

// MARK: - ImagePreview
struct ImagePreview: View {
  let url: URL
  
  var body: some View {
    if let image = UIImage(contentsOfFile: url.path) {
      Image(uiImage: image)
        .resizable()
        .scaledToFill()
        .clipped()
        .cornerRadius(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    } else {
      Image(systemName: "photo")
        .foregroundColor(.white)
    }
  }
}
