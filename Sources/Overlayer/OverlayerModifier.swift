//
//  OverlayerModifier.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//

import SwiftUI

struct OverlayerOptionalModifier<Item: Equatable, ViewContent: View>: ViewModifier {
  var animation: Animation
  @Binding var item: Item?
  @ViewBuilder var viewContent: (Item) -> ViewContent
  
  @Environment(OverlayerManager.self) private var properties
  @State private var viewID: String?
  @State private var currentItem: Item?
  
  func body(content: Content) -> some View {
    content
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
        properties.views.append(.init(id: viewID, view: .init(viewContent(item))))
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


struct OverlayerModifier<ViewContent: View>: ViewModifier {
  var animation: Animation
  @Binding var show: Bool
  @ViewBuilder var viewContent: ViewContent

  @Environment(OverlayerManager.self) private var properties
  @State private var viewID: String?
  
  func body(content: Content) -> some View {
    content
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
        properties.views.append(.init(id: viewID, view: .init(viewContent)))
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
