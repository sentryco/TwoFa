import SwiftUI
//import HybridColor
/**
 * Preview (dark / light mode)
 * - Fixme: ⚠️️ Add support for preview container
 * - Fixme: ⚠️️ Use light gray for light mode and dark gray for darkmode?
 */
#Preview(traits: .fixedLayout(width: 200, height: 200)) {
   struct DebugContainer: View {
      var body: some View {
         // Creates an instance of GraphView for preview purposes
         GraphView(
            progress: .constant(0.18), // Represents the current progress as a fraction of the total, where 0.18 indicates 18% completion.
            threshold: .constant(0.2), // Sets the threshold value at 20%, used to trigger certain actions when exceeded.
            tintColors: .constant((.blue, .green, .red)), // Defines the colors used for tinting elements in the graph, in this case blue, green, and red.
            // ⚠️️ Use .init(light: lightGray.opacity(0.5), dark: darkGray.opacity(0.5)) (use hybridcolor package etc)
            backgroundStrokeColor: .constant(.gray), // Specifies the color of the background stroke of the graph as gray.
            lineWeight: .constant(4) // Determines the thickness of the line in the graph, set to 4 points.
         )
         .frame(width: 42, height: 42) // Sets the frame of the GraphView to 42x42 pixels.
         .padding() // Adds padding around the GraphView to separate it from adjacent UI elements.
      }
   }
//   return PreviewContainer {
       return DebugContainer()
         .frame(maxWidth: .infinity)
//         .background(Color.black/*Color.whiteOrBlack*/)
//   }
   .environment(\.colorScheme, .dark) // dark / light
   #if os(macOS)
   .frame(width: 200, height: 200)
   #endif
}
