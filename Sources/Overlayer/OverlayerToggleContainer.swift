//
//  OverlayerToggleContainer.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 24.03.25.
//

import Foundation
import SwiftUI

/// Container view that handles displaying an overlay when an optional item is present
public struct OverlayerContainer<Content: View, Item: Equatable, OverlayContent: View>: View {
  var animation: Animation? = .default
  @Binding var item: Item?
  @ViewBuilder var content: () -> Content
  @ViewBuilder var overlayContent: (Item) -> OverlayContent
  
  public init(animation: Animation?, item: Binding<Item?>, content: @escaping () -> Content, overlayContent: @escaping (Item) -> OverlayContent) {
    self.animation = animation
    self._item = item
    self.content = content
    self.overlayContent = overlayContent
  }
  
  @Environment(OverlayerManager.self) private var properties
  @State private var viewID: String?
  @State private var currentItem: Item?
  
  public var body: some View {
    content()
      .onChange(of: item) { oldValue, newValue in
        if let newValue {
          addView(for: newValue)
        } else {
          removeView()
        }
      }
  }
  
  private func addView(for item: Item) {
    if properties.window != nil {
      if viewID == nil {
        viewID = UUID().uuidString
      }
      
      guard let viewID else { return }
      currentItem = item
      
      removeView()
      
      if let animation {
        withAnimation(animation) {
          properties.views.append(.init(id: viewID, view: .init(overlayContent(item))))
        }
      } else {
        properties.views.append(.init(id: viewID, view: .init(overlayContent(item))))
      }
        
      properties.window?.makeKeyAndVisible()
    }
  }
  
  private func removeView() {
    if let viewID {
      if let animation {
        withAnimation(animation) {
          properties.views.removeAll(where: { $0.id == viewID })
        }
      } else {
        properties.views.removeAll(where: { $0.id == viewID })
      }
      
      currentItem = nil
    }
  }
}

public struct OverlayerToggleContainer<Content: View, OverlayContent: View>: View {
  var animation: Animation? = .default
  @Binding var show: Bool
  @ViewBuilder var content: () -> Content
  @ViewBuilder var overlayContent: () -> OverlayContent
  
  public init(animation: Animation?, show: Binding<Bool>, content: @escaping () -> Content, overlayContent: @escaping () -> OverlayContent) {
    self.animation = animation
    self._show = show
    self.content = content
    self.overlayContent = overlayContent
  }
  
  @Environment(OverlayerManager.self) private var properties
  @State private var viewID: String?
  
  public var body: some View {
    content()
      .onChange(of: show, initial: true) { oldValue, newValue in
        if newValue {
          addView()
        } else {
          removeView()
        }
      }
  }
  
  private func addView() {
    if properties.window != nil && viewID == nil {
      viewID = UUID().uuidString
      guard let viewID else { return }
      
      if let animation {
        withAnimation(animation) {
          properties.views.append(.init(id: viewID, view: .init(overlayContent())))
        }
      } else {
        properties.views.append(.init(id: viewID, view: .init(overlayContent())))
      }
    }
  }
  
  private func removeView() {
    if let viewID {
      if let animation {
        withAnimation(animation) {
          properties.views.removeAll(where: { $0.id == viewID })
        }
      } else {
        properties.views.removeAll(where: { $0.id == viewID })
      }
      
      self.viewID = nil
    }
  }
}
