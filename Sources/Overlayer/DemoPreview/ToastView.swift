
//
//  ToastView.swift
//  OverlayerDemo
//
//  Created by Tornike Gomareli on 02.03.25.
//

import SwiftUI

struct ToastView: View {
  var message: String
  
  var body: some View {
    VStack {
      Text(message)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
        .shadow(radius: 3)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .padding(.top, 100)
    .transition(.move(edge: .top).combined(with: .opacity))
  }
}
