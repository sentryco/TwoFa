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
       * - Note: Needed for public init
       * - Parameters:
       *   - tints: - Fixme: ⚠️️ Add doc
       *   - iconSize: - Fixme: ⚠️️ Add doc
       *   - font: - Fixme: ⚠️️ Add doc
       *   - fontColor: - Fixme: ⚠️️ Add doc
       *   - bgStrokColor: - Fixme: ⚠️️ Add doc
       *   - background: - Fixme: ⚠️️ Add doc
       *   - lineWidth: - Fixme: ⚠️️ Add doc
       */
      public init(tints: (idle: Color, start: Color, end: Color), iconSize: CGFloat, font: Font, fontColor: Color, bgStrokColor: Color, background: Color, lineWidth: CGFloat) {
         self.tints = tints
         self.iconSize = iconSize
         self.font = font
         self.fontColor = fontColor
         self.bgStrokColor = bgStrokColor
         self.background = background
         self.lineWidth = lineWidth
      }
      /**
       * Default graph style
       */
      public static var defaultGraphStyle: GraphStyle {
         .init(
            tints: (.blue, .green, .red),
            iconSize: 24,
            font: .system(size: 12, weight: .bold, design: .monospaced),
            fontColor: .gray,
            bgStrokColor: .gray,
            background: .clear,
            lineWidth: 3
         )
      }
   }
}
