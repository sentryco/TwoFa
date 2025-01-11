import SwiftUI
//import HybridColor
/**
 * Getter
 */
extension GraphView {
   /**
    * Get current color
    * - Description: This computed property returns the appropriate color for the progress bar based on the current progress and threshold values. If the progress is less than the threshold, it returns the start color. If the progress is greater than 1 minus the threshold, it returns the end color. Otherwise, it returns the idle color.
    */
   internal var color: Color { // Style
      switch progress {
      case ..<threshold:
         // Return the start color if the progress is less than the threshold
         return tintColors.start
      case (1 - threshold)...:
         // Return the end color if the progress is greater than 1 minus the threshold
         return tintColors.end
      default:
         // Return the idle color if the progress is between the threshold and 1 minus the threshold
         return tintColors.idle
      }
   }
}
