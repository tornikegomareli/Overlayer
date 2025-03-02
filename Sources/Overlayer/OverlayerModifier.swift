//  OverlayerModifier.swift
import SwiftUI
import Observation

public struct OverlayerModifier<ViewContent: View>: ViewModifier {
  var animation: Animation
  @Binding var isPresented: Bool
  @ViewBuilder var viewContent: ViewContent
  
  @Environment(OverlayerManager.self) public var properties

  @State private var viewID: String?
  
  public func body(content: Content) -> some View {
    content
      .onChange(of: isPresented, initial: true) { oldValue, newValue in
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
