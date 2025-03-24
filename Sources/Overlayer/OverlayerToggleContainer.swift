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
  var animation: Animation = .default
  @Binding var item: Item?
  @ViewBuilder var content: () -> Content
  @ViewBuilder var overlayContent: (Item) -> OverlayContent
  
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
      
      withAnimation(animation) {
        properties.views.append(.init(id: viewID, view: .init(overlayContent(item))))
      }
    }
  }
  
  private func removeView() {
    if let viewID {
      withAnimation(animation) {
        properties.views.removeAll(where: { $0.id == viewID })
      }
      
      currentItem = nil
    }
  }
}

public struct OverlayerToggleContainer<Content: View, OverlayContent: View>: View {
  var animation: Animation = .default
  @Binding var show: Bool
  @ViewBuilder var content: () -> Content
  @ViewBuilder var overlayContent: () -> OverlayContent
  
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
      
      withAnimation(animation) {
        properties.views.append(.init(id: viewID, view: .init(overlayContent())))
      }
    }
  }
  
  private func removeView() {
    if let viewID {
      withAnimation(animation) {
        properties.views.removeAll(where: { $0.id == viewID })
      }
      
      self.viewID = nil
    }
  }
}
