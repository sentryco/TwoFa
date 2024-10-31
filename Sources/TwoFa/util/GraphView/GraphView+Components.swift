import SwiftUI
//import HybridColor
/**
 * Components
 */
extension GraphView {
   /**
    * Foreground
    * - Description: The foreground component of the GraphView, which is a partial circle that represents the current progress. It is styled with the color based on the current progress and threshold values, and has a line weight that determines its thickness. The circle is trimmed according to the progress value, creating the progress indicator effect.
    */
   internal var foreground: some View {
      Circle() // Draw the background circle
         .trim(from: 0.0, to: progress) // Trim the circle to draw the full circle
         .stroke( // Applies a stroke to the circle
            color,// Sets the color of the background stroke
            style: StrokeStyle( // Initializes a new StrokeStyle
               lineWidth: lineWeight, // Sets the width of the line
               lineCap: .round, // Sets the cap style of the line to round
               lineJoin: .round // Sets the join style of the line to round
            )
         ) // Set the stroke color and style for the background circle
   }
   /**
    * Background
    * - Description: The background component of the GraphView, which is a full circle that serves as the backdrop for the progress indicator. It is styled with the backgroundStrokeColor and has the same line weight as the foreground progress circle but remains static, indicating the full extent of the progress track.
    */
   internal var background: some View {
      Circle() // Draw the progress circle
         .trim(from: 0.0, to: 1.0) // Trims the circle to draw the progress
         .stroke( // Applies a stroke to the circle
            backgroundStrokeColor, // Sets the color of the progress circle
            style: StrokeStyle( // Initializes a new StrokeStyle
               lineWidth: lineWeight, // Sets the width of the line
               lineCap: .round, // Sets the cap style of the line to round
               lineJoin: .round // Sets the join style of the line to round
            )
         ) // Set the stroke color and style for the progress circle
   }
}
