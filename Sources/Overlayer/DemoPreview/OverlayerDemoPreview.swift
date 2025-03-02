
//
//  OverlayerDemo.swift
//  Overlayer
//
//  Created by Balaji Venkatesh on 21/10/24.
//

import SwiftUI
import AVKit

struct AdvancedDemo: View {
  @State private var showAlert = false
  @State private var showSheet = false
  @State private var showFullScreenCover = false
  @State private var showPiP = false
  @State private var showToastOnSheet = false
  
  var body: some View {
    NavigationStack {
      List {
        Section("Basic Demo") {
          Button("Show Alert Overlay") {
            showAlert.toggle()
          }
          
          Button("Toggle Picture-in-Picture") {
            showPiP.toggle()
          }
        }
        
        Section("Advanced Demo") {
          Button("Show Sheet + Overlay") {
            showSheet.toggle()
          }
          
          Button("Show Full Screen Cover + Overlay") {
            showFullScreenCover.toggle()
          }
        }
        
        Section {
          Text("Key Advantage")
            .font(.headline)
          
          Text("Overlayer can display UI components on top of sheets, full screen covers, and other modal presentations because it uses a separate window.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      .navigationTitle("Overlayer Demo")
      
      // Add alert overlay
      .overlayer(isPresented: $showAlert) {
        CustomAlertView(isPresented: $showAlert)
      }
      
      // Add PiP overlay
      .overlayer(isPresented: $showPiP) {
        PictureInPictureView(isPresented: $showPiP)
      }
      
      // Add Sheet with its own overlay ability
      .sheet(isPresented: $showSheet) {
        SheetWithOverlayView(showToast: $showToastOnSheet)
          .overlayer(isPresented: $showToastOnSheet) {
            ToastView(message: "Toast on top of a sheet!")
          }
      }
      
      // Add FullScreenCover with overlay
      .fullScreenCover(isPresented: $showFullScreenCover) {
        FullScreenWithOverlayView(isPresented: $showFullScreenCover)
      }
    }
  }
}

// MARK: - Custom Views

struct CustomAlertView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.4)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
          isPresented = false
        }
      
      VStack(spacing: 20) {
        Text("Custom Alert")
          .font(.headline)
          .padding(.top)
        
        Text("This is a custom alert created using Overlayer!")
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
        Button("Dismiss") {
          isPresented = false
        }
        .buttonStyle(.bordered)
        .tint(.blue)
        .padding(.bottom)
      }
      .frame(width: 300)
      .background(.regularMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .shadow(radius: 10)
    }
    .transition(.opacity.combined(with: .scale))
  }
}

struct PictureInPictureView: View {
  @Binding var isPresented: Bool
  @State private var position = CGPoint(x: UIScreen.main.bounds.width - 150, y: 100)
  @State private var isDragging = false
  
  public init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
  }
  
  
  // Create a sample AVPlayer with a bundled video
  // In real app, replace with actual video URL
  private var player: AVPlayer = {
    // Using a sample video URL - replace with your actual video
    guard let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {
      fatalError("Invalid URL")
    }
    return AVPlayer(url: url)
  }()
  
  var body: some View {
    VStack {
      // Close button
      HStack {
        Spacer()
        Button {
          isPresented = false
        } label: {
          Image(systemName: "xmark")
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
        }
        .padding(8)
      }
      
      // Video player
      VideoPlayer(player: player)
        .aspectRatio(16/9, contentMode: .fit)
        .cornerRadius(12)
        .frame(width: 200, height: 120)
        .onAppear {
          player.play()
        }
        .onDisappear {
          player.pause()
        }
    }
    .frame(width: 200)
    .background(Color.black.opacity(0.7))
    .cornerRadius(16)
    .shadow(radius: 10)
    .position(position)
    .gesture(
      DragGesture()
        .onChanged { value in
          position = value.location
          isDragging = true
        }
        .onEnded { _ in
          isDragging = false
          
          // Keep within screen bounds
          let screenSize = UIScreen.main.bounds.size
          let width = 200 / 2
          let height = 150 / 2
          
          position.x = min(max(CGFloat(width), position.x), screenSize.width - CGFloat(width))
          position.y = min(max(CGFloat(height), position.y), screenSize.height - CGFloat(height))
        }
    )
    .scaleEffect(isDragging ? 1.05 : 1.0)
    .animation(.spring(response: 0.3), value: isDragging)
  }
}

struct SheetWithOverlayView: View {
  @Binding var showToast: Bool
  @State private var showAlertOnSheet = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 30) {
        Text("This is a sheet presentation")
          .font(.title2)
        
        Divider()
        
        Text("Overlayer can display UI over native sheets")
          .multilineTextAlignment(.center)
          .padding()
          .background(Color.blue.opacity(0.1))
          .cornerRadius(10)
        
        Button("Show Toast On Sheet") {
          showToast = true
          
          // Auto-dismiss toast after 2 seconds
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
          }
        }
        .buttonStyle(.borderedProminent)
        
        Button("Show Alert On Sheet") {
          showAlertOnSheet = true
        }
        .buttonStyle(.bordered)
      }
      .padding()
      .navigationTitle("Sheet Demo")
      .navigationBarTitleDisplayMode(.inline)
      
      // Add another overlay on top of the sheet
      .overlayer(isPresented: $showAlertOnSheet) {
        CustomAlertView(isPresented: $showAlertOnSheet)
      }
    }
  }
}

struct FullScreenWithOverlayView: View {
  @Binding var isPresented: Bool
  @State private var showOverlayOnFullScreen = false
  
  var body: some View {
    ZStack {
      // Background gradient
      LinearGradient(
        colors: [.purple, .blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      VStack(spacing: 30) {
        Text("Full Screen Cover")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
        
        Text("Overlayer can display UI components on top of full screen modals")
          .multilineTextAlignment(.center)
          .foregroundColor(.white)
          .padding()
          .background(.ultraThinMaterial)
          .cornerRadius(10)
        
        Button("Show PiP on Full Screen") {
          showOverlayOnFullScreen = true
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
        .foregroundColor(.blue)
        
        Button("Dismiss") {
          isPresented = false
        }
        .buttonStyle(.bordered)
        .tint(.white)
        .padding(.top, 50)
      }
      .padding()
    }
    .overlayer(isPresented: $showOverlayOnFullScreen) {
      PictureInPictureView(isPresented: $showOverlayOnFullScreen)
    }
  }
}

// MARK: - Preview
#Preview {
  OverlayerRootView {
    AdvancedDemo()
  }
}
