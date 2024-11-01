import SwiftUI
/**
 * Const
 */
extension OTPArc {
   /**
    * - Note We could also embedd graphView with generics, but init code would not be minimal etc. this way it stays minimal
    */
   public struct GraphStyle {
      internal let tints: (idle: Color, start: Color, end: Color)
      internal let iconSize: CGFloat
      internal let font: Font
      internal let fontColor: Color
      internal let bgStrokColor: Color
      internal let background: Color
      internal let lineWidth: CGFloat
      /**
       * Default graph style
       */
      public static let defaultGraphStyle: GraphStyle = {
         .init(
            tints: (.blue, .green, .red),
            iconSize: 24,
            font: .system(size: 12, weight: .bold, design: .monospaced),
            fontColor: .gray,
            bgStrokColor: .gray,
            background: .clear,
            lineWidth: 3
         )
      }()
   }
}
