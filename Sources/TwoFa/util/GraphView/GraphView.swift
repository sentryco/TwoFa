import SwiftUI
//import HybridColor
/**
 * This SwiftUI GraphProgressView struct creates a circular progress bar similar to the UIKit GraphProgressView class. The @State property wrapper is used to create mutable state for the progress, threshold, tintColors, backgroundStrokeColor, and lineWeight properties. The body property returns a ZStack that contains two Circle views that represent the background and foreground of the progress bar. The trim(from:to:) modifier is used to create the progress effect, and the stroke(_:style:) modifier is used to set the stroke color and style of the circles. The rotationEffect(_:) modifier is used to rotate the ZStack so that the progress starts from the top. The color computed property returns the appropriate color based on the current progress.
 * - Description: A view that shows a circular progress bar
 * - Note: Used by `OTPArc` and `AuditView`
 * - Note: Works for iOS and macOS
 * - Fixme: ⚠️️ Animate graph in onApear, maybe later?
 * - Fixme: ⚠️️ Transfer more of the comments from legacy 👈
 * - Fixme: ⚠️️ Move to TwoFA scope?
 */
public struct GraphView: View {
   /**
    * Progress from 0-1
    * - Description: The current progress of the graph, represented as a value from 0.0 (no progress) to 1.0 (complete progress).
    */
   @Binding internal var progress: CGFloat
   /**
    * When should the time threshold indication be turned on (green / red)
    * - Description: The threshold value at which the progress bar changes color to indicate a warning or critical state. For example, if the threshold is set to 0.5, the progress bar will change color when the progress reaches or exceeds 50%.
    */
   @Binding internal var threshold: CGFloat // - Important: ⚠️️ notice that idle comes before start etc, use labels if needed
   /**
    * Set tint colors - Foreground color
    * - Description: The colors used to tint the progress bar, which can change based on the current progress in relation to the threshold. The tuple contains colors for normal progress, warning progress, and critical progress states.
    */
   @Binding internal var tintColors: TintColors
   /**
    * The stroke color for the background of the graph
    * - Description: The color used for the background stroke of the progress bar. This color remains constant regardless of the progress or threshold values.
    */
   @Binding internal var backgroundStrokeColor: Color
   /**
    * Line-weight - Filled or stroked
    * - Description: The line weight determines the thickness of the progress bar. A higher value will result in a thicker bar, while a lower value will result in a thinner bar.
    */
   @Binding internal var lineWeight: CGFloat
   /**
    * - Description: A placeholder for additional documentation or description of functionality that may be added in the future.
    * - Parameters:
    *   - progress: The progress value from 0 to 1 that determines the amount of the circle that is filled.
    *   - threshold: The threshold value that determines when the progress bar color changes to indicate a warning or critical state.
    *   - tintColors: A tuple of three colors that represent the tint colors for the progress bar at different stages (e.g., normal, warning, critical).
    *   - backgroundStrokeColor: The color of the background stroke of the progress bar.
    *   - lineWeight: The width of the line that makes up the progress bar.
    */
   public init(progress: Binding<CGFloat> = .constant(0), threshold: Binding<CGFloat> = .constant(0.2), tintColors: Binding<TintColors> = .constant((Color.blue, Color.green, Color.red)), backgroundStrokeColor: Binding<Color> = .constant(Color.gray), lineWeight: Binding<CGFloat> = .constant(4)) {
      self._progress = progress
      self._threshold = threshold
      self._tintColors = tintColors
      self._backgroundStrokeColor = backgroundStrokeColor
      self._lineWeight = lineWeight
   }
}
