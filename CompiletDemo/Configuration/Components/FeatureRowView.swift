//
//  FeatureRowView.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 03/11/2025.
//

import SwiftUI

// MARK: - Feature Row Component
struct FeatureRowView: View {
  let title: String
  let subtitle: String
  let icon: String
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .foregroundColor(.blue)
        .font(.title2)
        .frame(width: 32)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
        
        Text(subtitle)
          .font(.caption)
          .foregroundColor(.secondary)
          .lineLimit(2)
      }
      
      Spacer()
    }
    .padding(.vertical, 4)
  }
}
