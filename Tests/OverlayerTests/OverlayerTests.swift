import Testing
import SwiftUI
@testable import Overlayer

@Test func testOverlayerManagerInitialState() {
  let manager = OverlayerManager()
  
  #expect(manager.views.isEmpty)
  #expect(manager.window == nil)
}

@Test func testOverlayerManagerAddRemoveViews() {
  let manager = OverlayerManager()
  let testView = AnyView(Text("Test View"))
  let id = "test-id"
  
  manager.views.append(.init(id: id, view: testView))
  
  #expect(manager.views.count == 1)
  #expect(manager.views[0].id == id)
  
  manager.views.removeAll(where: { $0.id == id })
  
  #expect(manager.views.isEmpty)
}
