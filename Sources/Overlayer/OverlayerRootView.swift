//
//  OverlayerRootView.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//

import SwiftUI

public struct OverlayerRootView<Content: View>: View {
  var content: Content
  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  public var properties = OverlayerManager()

  public var body: some View {
    content
      .environment(properties)
      .onAppear {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene), properties.window == nil {
          let window = PassThroughWindow(windowScene: windowScene)
          window.isHidden = false
          window.isUserInteractionEnabled = true
          let rootViewController = UIHostingController(rootView: OverlayerViews().environment(properties))
          rootViewController.view.backgroundColor = .clear
          window.rootViewController = rootViewController
          
          properties.window = window
        }
      }
  }
}

private struct OverlayerViews: View {
  @Environment(OverlayerManager.self) private var properties
  var body: some View {
    ZStack {
      ForEach(properties.views) {
        $0.view
      }
    }
  }
}
