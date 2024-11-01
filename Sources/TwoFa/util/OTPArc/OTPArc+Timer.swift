import SwiftUI
/**
 * Timer
 */
extension OTPArc {
   /**
    * Create `OTPTimer` instance
    * - Abstract: Create `OTPTimer` (Counts down and repeats)
    * - Description: Initializes and returns an `OTPTimer` instance that 
    *                periodically updates the OTP progress and triggers 
    *                UI updates accordingly.
    * - Note: Alternative name `initiateOTPTimer`
    * - Remark: Get OTPValue from value (value is OTP URL)
    * - Remark: TOTP example value: "otpauth://totp/test?secret=GEZDGNBV"
    * - Fixme: ⚠️️ Timer code https://stackoverflow.com/a/76681369/5389500
    * - Fixme: ⚠️️⚠️️ More on stopping and starting timer in swiftui: https://sarunw.com/posts/timer-in-swiftui/
    */
   internal func initOTPTimer() -> OTPTimer {
      OTPTimer { (_ otpTimer: OTPTimer) in // Update UI on timer synced to OTP time on every tick
         stateManager.progress = CGFloat(otpProgress ?? 0) // calculate the progress of the OTP timer based on the current date and the period of the account's OTP
      }.start() // Starts OTPTimer that updates text
   }
}
