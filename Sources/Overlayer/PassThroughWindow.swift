//
//  PassThroughWindow.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//

import UIKit

class PassThroughWindow: UIWindow {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let hitView = super.hitTest(point, with: event),
          let rootView = rootViewController?.view
    else { return nil }
    
    if #available(iOS 18, *) {
      for subview in rootView.subviews.reversed() {
        let pointInSubView = subview.convert(point, from: rootView)
        if subview.hitTest(pointInSubView, with: event) != nil {
          return hitView
        }
      }
      
      return nil
    } else {
      return hitView == rootView ? nil : hitView
    }
  }
}
