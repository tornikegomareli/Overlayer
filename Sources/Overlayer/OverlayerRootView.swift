//
//  OverlayerRootView.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//


//  OverlayerRootView.swift
import SwiftUI

struct OverlayerRootView<Content: View>: View {
    private let content: Content
    private let manager = OverlayerManager()
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(manager)
            .task(configureWindow)
    }
    
    @MainActor
    private func configureWindow() {
        guard manager.window == nil,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return }
        
        let window = PassThroughWindow(windowScene: windowScene)
        window.isHidden = false
        window.isUserInteractionEnabled = true
        
        let rootVC = UIHostingController(rootView: OverlayerContainerView())
        rootVC.view.backgroundColor = .clear
        window.rootViewController = rootVC
        
        manager.window = window
    }
}

private struct OverlayerContainerView: View {
    @Environment(OverlayerManager.self) private var manager
    
    var body: some View {
        ZStack {
            ForEach(manager.views) { $0.view }
        }
        .allowsHitTesting(false)
    }
}