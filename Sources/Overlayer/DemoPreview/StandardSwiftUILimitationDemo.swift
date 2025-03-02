
//
//  StandardSwiftUILimitationDemo.swift
//  OverlayerDemo
//
//  Created by Tornike Gomareli on 02.03.25.
//


//
//  StandardSwiftUILimitationDemo.swift
//  SwiftUILimitations
//
//  Created on 02.03.25.
//

import SwiftUI

struct StandardSwiftUILimitationDemo: View {
  @State private var showToast = false
  @State private var showSheet = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("Standard SwiftUI Toast & Sheet")
          .font(.title2)
          .fontWeight(.bold)
        
        Text("This demo shows why ZStack is insufficient for global overlays")
          .multilineTextAlignment(.center)
          .padding(.horizontal)
          .foregroundColor(.secondary)
        
        Divider()
          .padding(.vertical)
        
        Button("Show Toast") {
          showToast = true
          
          // Auto-hide toast after 2 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
          }
        }
        .buttonStyle(.borderedProminent)
        
        Button("Show Sheet") {
          showSheet = true
        }
        .buttonStyle(.bordered)
        
        Button("Show Toast Then Sheet") {
          // First show toast
          showToast = true
          
          // Then show sheet after 0.5 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showSheet = true
          }
          
          // Auto-hide toast after 2 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
          }
        }
        .buttonStyle(.borderedProminent)
        
        Spacer()
        
        Text("⚠️ When a sheet is presented, any toast in the ZStack becomes invisible because it's part of the parent view hierarchy which is covered by the sheet.")
          .font(.footnote)
          .multilineTextAlignment(.center)
          .padding()
          .background(Color.yellow.opacity(0.2))
          .cornerRadius(8)
          .padding(.horizontal)
      }
      .padding()
      .navigationTitle("Standard SwiftUI")
      
      // Toast overlay using ZStack
      .overlay {
        if showToast {
          VStack {
            Text("This is a toast message")
              .padding()
              .background(.regularMaterial)
              .cornerRadius(8)
              .shadow(radius: 3)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
          .padding(.top, 100)
          .transition(.move(edge: .top).combined(with: .opacity))
          .animation(.easeInOut, value: showToast)
          .zIndex(100) // Even a high z-index doesn't help with sheets
        }
      }
      
      // Sheet presentation
      .sheet(isPresented: $showSheet) {
        SheetView(isPresented: $showSheet)
      }
    }
  }
}

struct SheetView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("This is a Sheet")
          .font(.title2)
          .padding(.top, 30)
        
        Text("Notice that the toast is no longer visible, even though it should still be showing based on the timer.")
          .multilineTextAlignment(.center)
          .padding(.horizontal)
          .foregroundColor(.secondary)
        
        Spacer()
      }
      .navigationTitle("Sheet View")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Dismiss") {
            isPresented = false
          }
        }
      }
    }
  }
}

// MARK: - Preview
#Preview {
  StandardSwiftUILimitationDemo()
}
