/**
 * Import the required modules and define platform-specific typealiases
 * - Note: This code imports the required modules for the GraphProgressView
 *         class and defines platform-specific typealiases for `Color` and
 *         `View`.
 * - Warning: ⚠️️ This code assumes that the platform is either iOS or macOS. It may not work on other platforms.
 */
#if os(iOS)
import UIKit // Import the UIKit module for iOS
public typealias OSColor = UIColor // Define the `Color` typealias as `UIColor` for iOS
public typealias OSView = UIView // Define the `OSView` typealias as `UIView` for iOS
#elseif os(macOS)
import Cocoa // Import the Cocoa module for macOS
public typealias OSColor = NSColor // Define the `Color` typealias as `NSColor` for macOS
public typealias OSView = NSView // Define the `OSView` typealias as `NSView` for macOS
#endif
/**
 * A view that shows a circular progress bar
 * - Description: The `GraphProgressView` class provides a customizable
 *                circular progress bar that visually represents a percentage
 *                value. The progress is indicated by a filled arc that can
 *                change color based on predefined thresholds.
 * fixme: add the swiftui version as well? or is that a wrapper around this?
 * - Remark: works for iOS and macOS
 * ## Example:
 * addSubview(GraphProgressView())
 * graphProgressView.progress = 0.6
 */
public final class GraphProgressView: OSView {
   #if os(macOS)
   override public var isFlipped: Bool { true } // Set the view's orientation to TopLeft
   #endif
   /**
    * When should the time threshold indication be turned on (green / red)
    * - Description: The `threshold` property defines the point at which the
    *                progress bar changes color to indicate a warning (e.g., from
    *                green to red). A lower threshold means the color change will
    *                happen earlier as progress increases.
    */
   public var threshold: CGFloat = 0.2 { // The threshold value for the graph progress
      didSet { // Property observer that redraws the graph when the threshold value changes
         drawGraphic() // Redraw the graph when the threshold value changes
      }
   }
   /**
    * Progress from 0-1
    * - Description: This property represents the progress of the circular
    *                progress bar. It ranges from 0 to 1, where 0 means no
    *                progress and 1 means the task is complete.
    */
   public var progress: CGFloat = 0.0 { // The progress value for the graph
      didSet { // Property observer that redraws the graph when the progress value changes
         drawGraphic() // Redraw the graph when the progress value changes
      }
   }
   /**
    * Set tint colors
    * - Description: This property allows you to set the tint colors for 
    *                different states of the progress bar. It is a tuple 
    *                containing three colors for idle, start, and end states 
    *                respectively. The idle color is used when there is no 
    *                progress, the start color is used at the beginning of the 
    *                progress, and the end color is used when the progress is 
    *                complete.
    * - Remark: Foreground color
    * - Remark: These can also be set exernally etc
    */
   public var tintColors: TintColors = (.systemBlue, .systemGreen, .systemRed) { // The tint colors for the graph
      didSet { // Property observer that redraws the graph when the tint colors change
         drawGraphic() // Redraw the graph when the tint colors change
      }
   }
   /**
    * The stroke color for the background of the graph.
    * - Description: This property sets the color used for the circular
    *                progress bar's background stroke. It visually distinguishes
    *                the progress path from the rest of the view. By default, it
    *                is set to a dark gray color.
    * - Note: This property is used to set the stroke color for the background of the graph.
    * - Warning: This property is not documented yet.
    */
   public var backgroundStrokeColor: OSColor = .darkGray {
      didSet { // Property observer that redraws the graph when the stroke color changes
         drawGraphic() // Redraw the graph when the stroke color changes
      }
   }
   /**
    * Line-weight
    * - Description: This property defines the thickness of the progress bar's
    *                stroke. A larger value results in a thicker stroke, making
    *                the progress bar more prominent. Conversely, a smaller value
    *                results in a thinner stroke, giving the progress bar a more
    *                subtle appearance.
    * - Remark: Filled or stroked
    */
   public var lineWeight: CGFloat = 4 { // The line weight for the graph
      didSet { // Property observer that redraws the graph when the line weight changes
         drawGraphic() // Redraw the graph when the line weight changes
      }
   }
}
/**
 * Type
 */
extension GraphProgressView {
   /**
    * Container for the colors used in the arc stroke
    * - Description: Represents a set of colors used at different stages of the
    *                progress within the `GraphProgressView`. The `idle` color is
    *                used when there is no progress, the `start` color is used at
    *                the beginning of the progress, and the `end` color is used
    *                when the progress is nearing completion.
    */
   public typealias TintColors = (
      idle: OSColor, // The color for the idle state of the graph
      start: OSColor, // The color for the start state of the graph
      end: OSColor // The color for the end state of the graph
   )
}
/**
 * Helper
 */
extension GraphProgressView {
   /**
    * We don't call this method directly, calling the variables will indirectly call it via setNeedsDisplay
    * - Description: This method is called when the view needs to be redrawn.
    *                This can happen when the view's bounds change, its properties
    *                change, or when the system explicitly calls for a redraw.
    *                This method is overridden to draw the graph on top of the
    *                view's background.
    * - Remark: When appearance change, this is redrawn
    * - Parameter rect: Size and placment of arc
    */
   override public func draw(_ rect: CGRect) {
      super.draw(rect) // Call the superclass's draw method to draw the view's background
      drawGraphic() // Call the `drawGraphic()` method to draw the graph on top of the view's background
   }
}
/**
 * Helper
 */
extension GraphProgressView {
   /**
    * Get current color
    * - Description: This computed property returns the current color of the
    *                graph based on the progress and threshold values. If the
    *                progress is less than the threshold, it returns the start
    *                color. If the progress is greater than 1 minus the threshold,
    *                it returns the end color. Otherwise, it returns the idle
    *                color.
    * - Remark: This method returns the current color of the graph based on the progress and threshold values.
    */
   public var color: OSColor { // Style
       // Determine the color based on the progress and threshold
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
   /**
    * Draw graphic
    * - Description: This method is responsible for drawing the graph's
    *                foreground and background arcs. It first removes any
    *                existing sublayers to prepare for a fresh draw. Then, it
    *                creates and adds a background arc with full progress to
    *                visually represent the track on which the foreground arc
    *                will animate. Finally, it creates and adds a foreground arc
    *                that represents the current progress of the task or timer,
    *                using the color that reflects the current state based on the
    *                progress and threshold values.
    * - Remark: This method draws the graph on top of the view's background.
    */
   fileprivate func drawGraphic() {
      let layer: CALayer? = { // Adds the cross-platform support iOS / macOS
         #if os(iOS)
         return Optional(self.layer) // We make it optional, or else we get compiler warning etc
         #elseif os(macOS)
         return self.layer // Return the layer of the view
         #endif
      }()
      layer?.sublayers?.forEach { $0.removeFromSuperlayer() } // Remove any existing sublayers from the layer
      let background: CAShapeLayer = createArcShape(
         lineColor: backgroundStrokeColor, // Sets the color of the line to the background stroke color
         progress: 1 // Sets the progress to 1, indicating the shape should be fully drawn
      ) // Create a background arc shape with a stroke color of `backgroundStrokeColor` and a progress of 1
      layer?.addSublayer(background) // Add the background arc shape to the layer
      let foreground: CAShapeLayer = createArcShape(
         lineColor: color, // Sets the color of the line to the color   
         progress: self.progress // Sets the progress to the current progress of the view
      ) // Create a foreground arc shape with a stroke color of `color` and a progress of `self.progress`
      layer?.addSublayer(foreground) // Add the foreground arc shape to the layer
   }
   /**
    * Draws the arc shape
    * - Description: This method creates an arc shape layer with a specified
    *                line color and progress. The arc shape layer is used to
    *                visually represent the progress of a task or timer in the
    *                GraphProgressView.
    * - Remark: This method creates an arc shape with a given line color and progress.
    * - Parameters:
    *   - lineColor: color of line
    *   - progress: 0-1
    */
   fileprivate func createArcShape(lineColor: OSColor, progress: CGFloat) -> CAShapeLayer {
      let center: CGPoint = .init(x: self.bounds.midX, y: self.bounds.midY) // Get the center point of the view
      let radius: CGFloat = max(self.bounds.size.height / 1.0, self.bounds.size.width / 1.0) - lineWeight // Calculate the radius of the arc shape
      let path: CGMutablePath = .init() // Create a new mutable path
      path.move(to: CGPoint(x: center.x, y: center.y - radius / 2)) // Move the path to the starting point of the arc shape
      let startAngle: CGFloat = -CGFloat.pi / 2 // Set the start angle of the arc shape to center top
      let endAngle: CGFloat = (CGFloat.pi / 2) * 3 // Set the end angle of the arc shape to 3/4 around the circle (center right to center top)
      path.addArc(
         center: CGPoint(x: center.x, y: center.y), // The center point of the arc
         radius: radius / 2, // The radius of the arc
         startAngle: startAngle, // The starting angle of the arc
         endAngle: endAngle, // The ending angle of the arc
         clockwise: false // A Boolean value indicating whether the arc should be drawn clockwise or counterclockwise
      ) // Add an arc to the path with the specified center, radius, start angle, end angle, and direction
      let layer: CAShapeLayer = .init() // Create a new shape layer
      layer.fillColor = OSColor.clear.cgColor // Set the fill color of the shape layer to clear
      layer.strokeColor = lineColor.cgColor // Set the stroke color of the shape layer to the specified line color
      layer.lineWidth = lineWeight // Set the line width of the shape layer to the specified line weight
      layer.lineCap = .round // Set the line cap of the shape layer to round
      layer.lineJoin = .round // Set the line join of the shape layer to round
      layer.path = path // Set the path of the shape layer to the created path
      layer.strokeEnd = progress // Set the stroke end of the shape layer to the specified progress value
      return layer // Return the created shape layer
   }
}
