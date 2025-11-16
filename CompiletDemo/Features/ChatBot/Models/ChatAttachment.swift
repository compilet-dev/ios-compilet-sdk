//
//  ChatAttachment.swift
//  CompiletDemo
//
//  Created by Minh Nguyen on 16/11/2025.
//

import Foundation
import CompiletSDK

enum ChatAttachment: Equatable, Hashable, Identifiable {
  case image(url: URL)
  case audio(url: URL)
  
  var id: String {
    "\(type)-\(url.absoluteString)"
  }
  
  var url: URL {
    switch self {
    case .image(let url),
        .audio(let url):
      return url
    }
  }
  
  var data: Data? {
    try? Data(contentsOf: url)
  }
  
  var mimeType: MimeType {
    switch self {
    case .image: return .jpeg
    case .audio: return .mp3
    }
  }
  
  private var type: String {
    switch self {
    case .image: return "image"
    case .audio: return "audio"
    }
  }
}
