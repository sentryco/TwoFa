import SwiftUI
/**
 * Content
 */
extension GraphView {
   /**
    * Body
    * - Description: The main view of the GraphView which consists of a ZStack that layers the background and foreground components to create a circular progress indicator. The entire ZStack is rotated by -90 degrees to ensure the progress starts from the top.
    */
   public var body: some View {
      ZStack {
         background
         foreground
      }
      .rotationEffect(.degrees(-90)) // Rotates the view 90 degrees to align the progress circle with the x-axis
   }
}
