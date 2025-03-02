//
//  PassThroughWindow.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//


//  PassThroughWindow.swift
import UIKit

final class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event),
              let rootView = rootViewController?.view
        else { return nil }
        
        return hitView == rootView ? nil : hitView
    }
}