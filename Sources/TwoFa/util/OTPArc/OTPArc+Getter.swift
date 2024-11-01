import SwiftUI
/**
 * Getter
 */
extension OTPArc {
   /**
    * OTP Progress
    * - Description: Returns the current progress of the OTP as a CGFloat. 
    *               This progress is calculated based on the current 
    *               date and the period of the OTP account associated 
    *               with this view. If no account is associated, nil is 
    *               returned.
    */
   internal var otpProgress: CGFloat? {
      guard let account: OTPAccount = account else { Swift.print("⚠️️err acc"); return nil }
      return OTPTimer.progressForDate(date: .init(), period: account.otp.period)
   }
   /**
    * - Abstract: Gets the text to be displayed in the countdown label 
    *             based on the given progress value.
    * - Description: Calculates the countdown time remaining until the 
    *                next OTP generation, based on the current progress. 
    *                The countdown time is derived by subtracting the 
    *                current progress from the total period of the OTP, 
    *                providing a countdown from the total period to zero.
    * - Parameter progress: progress The current progress value, 
    *                       represented as a CGFloat between 0 and 1.
    * - Returns: The text to be displayed in the countdown label, or nil 
    *            if there is an error retrieving the account information.
    */
   internal func getCountDownLabelText(progress: CGFloat) -> String? {
       // The OTPAccount instance associated with the current context. If this value is nil, it indicates that no account information is available.
      guard let account: OTPAccount = account else { Swift.print("⚠️️err acc"); return nil }
       // The text to be displayed in the countdown label.
      // It is calculated by multiplying the account's OTP period with the current progress value.
      // The result is formatted as an integer value using the "%.00f" format specifier.
      let countDownLabelText: String = .init(format: "%.00f", account.otp.period * progress) // update clock text (0-30)
      // Update the clock text with a value between 0 and the account's OTP period
      return countDownLabelText
   }
}
