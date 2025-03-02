
import SwiftUI

struct OverlayerSolutionDemo: View {
  @State private var showToast = false
  @State private var showSheet = false
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("Overlayer Solution")
          .font(.title2)
          .fontWeight(.bold)
        
        Text("This demo shows how Overlayer lets toasts appear above sheets")
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
        
        Text("✅ When a sheet is presented, the toast remains visible because Overlayer uses a separate window that exists above the entire app hierarchy.")
          .font(.footnote)
          .multilineTextAlignment(.center)
          .padding()
          .background(Color.green.opacity(0.2))
          .cornerRadius(8)
          .padding(.horizontal)
      }
      .padding()
      .navigationTitle("Overlayer")
      
      // Using Overlayer for the toast
      .overlayer(isPresented: $showToast) {
        ToastView(message: "This is a toast message")
      }
      
      // Sheet presentation
      .sheet(isPresented: $showSheet) {
        OverlayerSheetView(isPresented: $showSheet)
      }
    }
  }
}

struct OverlayerSheetView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("This is a Sheet")
          .font(.title2)
          .padding(.top, 30)
        
        Text("Notice that the toast remains visible above this sheet because it's rendered in a separate window layer.")
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



// MARK: - Preview with OverlayerRootView
#Preview {
  OverlayerRootView {
    OverlayerSolutionDemo()
  }
}
