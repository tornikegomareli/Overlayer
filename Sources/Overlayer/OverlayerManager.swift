//
//  OverlayerManager.swift
//  Overlayer
//
//  Created by Tornike Gomareli on 02.03.25.
//

import SwiftUI
import Observation

@Observable
public class OverlayerManager {
  var window: UIWindow?
  var views: [OverlayView] = []
  
  struct OverlayView: Identifiable {
    var id: String = UUID().uuidString
    var view: AnyView
  }
}
