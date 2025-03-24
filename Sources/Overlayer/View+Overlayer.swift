//
//  View+Overlayer.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//


import SwiftUI

public extension View {
  @ViewBuilder
  func overlayer<Item: Equatable, Content: View>(
    animation: Animation = .snappy,
    item: Binding<Item?>,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    self
      .modifier(OverlayerOptionalModifier(animation: animation, item: item, viewContent: content))
  }
}

public extension View {
  @ViewBuilder
  func overlayer<Content: View>(
    animation: Animation = .snappy,
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self
      .modifier(OverlayerModifier(animation: animation, show: isPresented, viewContent: content))
  }
}

extension View {
  /// Convenience function to wrap a view in an OverlayerContainer
  func withOverlayer<Item: Equatable, OverlayContent: View>(
    item: Binding<Item?>,
    animation: Animation = .default,
    @ViewBuilder content: @escaping (Item) -> OverlayContent
  ) -> some View {
    OverlayerContainer(
      animation: animation,
      item: item,
      content: { self },
      overlayContent: content
    )
  }
  
  /// Convenience function to wrap a view in an OverlayerToggleContainer
  func withOverlayer<OverlayContent: View>(
    isPresented: Binding<Bool>,
    animation: Animation = .default,
    @ViewBuilder content: @escaping () -> OverlayContent
  ) -> some View {
    OverlayerToggleContainer(
      animation: animation,
      show: isPresented,
      content: { self },
      overlayContent: content
    )
  }
}
