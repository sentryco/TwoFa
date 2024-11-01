import SwiftUI
/**
 * Content
 * - Description: This extension provides the content for the OTPArc view, 
 *               including the countdown label and graph view.
 * - Note: The content is displayed within a ZStack to overlay the 
 *         countdown label on top of the graph view.
 */
extension OTPArc {
   /**
    * Body
    * - Description: The body of the `OTPArc` view is responsible for 
    *               displaying the main visual components of the OTP 
    *               feature, including a countdown label and a 
    *               dynamic graph view that visually represents the 
    *               time until the next OTP is generated.
    * - Fixme: ⚠️️ Maybe make sure onDisappear works, with some logging etc? is invalidated etc?
    * - Fixme: ⚠️️ debug this by doing some logging etc
    */
   public var body: some View {
      ZStack {
         countDownLabel
         graphView
      }
      .onDisappear { // - Fixme: ⚠️️ Maybe make sure this works, with some logging etc? is invalidated etc?
         // Perform cleanup or any other necessary actions here
         self.otpTimer?.stop()  // Stop the OTP timer
      }
   }
   /**
    * Creates `GraphView` representing the "OTP-count-down" visually
    * - Description: This method constructs the visual representation 
    *               of the OTP countdown using a circular progress 
    *               indicator, which dynamically updates as the OTP 
    *               timer counts down.
    * - Note: Arc graph (Shows how much time is left visually)
    * - Note: Called on init and every timer tick
    * - Remark: Get OTPValue from value (value is OTP URL)
    * - Remark: TOTP example value: "otpauth://totp/test?secret=GEZDGNBV"
    */
   internal var graphView: some View {
      // - Fixme: ⚠️️ move the tint colors to a struct, we can set on init
      return GraphView(
         progress: $stateManager.progress, // Update arc graph animation, Binds the progress value to the `stateManager.progress` property, which is a `@Published` property of the `ProgressStateManager` class.
         threshold: .constant(0.3), // Sets the threshold value for the progress indicator to 0.3.
         tintColors: .constant(graphStyle.tints), // Sets the tint colors for the progress indicator to blue, green, and red.
         backgroundStrokeColor: .constant(graphStyle.bgStrokColor), // Sets the background stroke color of the progress indicator to a semi-transparent gray color.
         lineWeight: .constant(graphStyle.lineWidth) // Sets the line weight (thickness) of the progress indicator to 4.
      )
      // - Fixme: ⚠️️ move size to init of otparc
      .frame(width: graphStyle.iconSize, height: graphStyle.iconSize) // - Fixme: ⚠️️ we should use some other metric that is dynamic
   }
   /**
    * countDownLabel
    * - Description: Displays the remaining time for the OTP in a numeric 
    *               format at the center of the graph view.
    * - Remark: Small label in the middle of the `GraphProgressView`
    * - Note: Numeric text label (shows count down time 30-0sec etc)
    * - Fixme: ⚠️️ 2fa clock should count down not up
    */
   internal var countDownLabel: some View {
      let countDownLabelText: String = getCountDownLabelText(progress: $stateManager.progress.wrappedValue) ?? "0"
      return Text(countDownLabelText) // update clock text (0-30)
      // - Fixme: ⚠️️ move to theme struct settable in init
         .font(graphStyle.font) // set the font to the countDown font /*.system(size: 12)*/
         // - Fixme: ⚠️️ move to theme struct settable in init
         .foregroundColor(graphStyle.fontColor) // set the text color to the title color from the palette /*Color.whiteOrBlack.opacity(0.8)*/
         .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures the view expands to fill all available space in both dimensions
         .background(graphStyle.background) // Sets a transparent background
      // - Fixme: ⚠️️ move size to init of otparc
         .frame(width: graphStyle.iconSize, height: graphStyle.iconSize) // Constrains the frame to a specific width and height based on a predefined metric
   }
}
