import SwiftUI

extension GraphView {
   /**
    * Container for the colors used in the arc stroke
    */
   public typealias TintColors = (
      idle: Color, // Represents the color when the progress is idle
      start: Color, // Represents the color at the start of the progress
      end: Color // Represents the color at the end of the progress
   )
}
