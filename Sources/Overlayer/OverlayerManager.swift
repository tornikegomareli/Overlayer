//  OverlayerManager.swift
import SwiftUI

@Observable
final class OverlayerManager {
    var window: UIWindow?
    fileprivate var views: [OverlayView] = []
    
    struct OverlayView: Identifiable {
        let id: String
        let view: AnyView
    }
}