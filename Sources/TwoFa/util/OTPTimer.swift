import Foundation
import QuartzCore
/**
 * The timer class that counts period (30-sec, 60-sec etc)
 * - Description: This class is responsible for managing the countdown timer
 *                for the OTP (One-Time Password) process. It provides
 *                functionality to start the timer, update it every second, and
 *                perform a callback function on each timer tick. This is
 *                crucial for OTPs, especially TOTP (Time-Based One-Time
 *                Password), where the OTP is valid only for a certain period
 *                of time (e.g., 30 or 60 seconds).
 */
public final class OTPTimer {
   /**
    * Ticker instance
    * - Description: This is the timer instance that is used to manage the
    *                countdown functionality in the OTP process.
    */
   fileprivate var timer: Timer?
   /**
    * Callback for timer ticks
    * - Description: The `onChange` closure is executed every time the timer
    *                ticks. It allows the OTPTimer to perform any necessary
    *                updates each second, such as refreshing the UI to show
    *                the remaining time for the OTP or updating the OTP value
    *                itself.
    */
   fileprivate var onChange: OTPTimerCallback = defaultOnChange
   /**
    * - Description: The `onChange` closure is executed every time the timer
    *                ticks. It allows for custom actions to be performed at
    *                each tick, such as updating a user interface or
    *                processing the remaining time.
    * ## Examples:
    * OTPTimer { [weak self] in
    *    guard self = self else { $0.stop() }
    *    self.graphView.progress = OTPTimer.progressForDate(date: Date(), period: 30)
    *    let account = try? Account(url: URL(string: "otpauth://totp/test?secret=GEZDGNBV")!)
    *    self.inputText = account?.currentPassword // 123321 etc
    * }.start()
    * - Parameter onChange: The callback that is called on each timer tick
    */
   public init(onChange: @escaping OTPTimerCallback) {
      self.onChange = onChange
   }
}
/**
 * Commands
 */
extension OTPTimer {
   /**
    * Start count down to the left over. on complete
    * - Description: This method starts the countdown timer for the OTP
    *                process. It creates a new timer that fires every second
    *                and adds it to the main run loop. The timer triggers the
    *                `update` method at each interval, which in turn triggers
    *                the `onChange` closure. This allows for custom actions to
    *                be performed at each tick, such as updating a user
    *                interface or processing the remaining time.
    * - Fixme: ⚠️️ add some doc regarding why we add timer to the main runloop`
    */
   @discardableResult public func start() -> OTPTimer {
      let timer: Timer = .init(
         timeInterval: 1, // The time interval at which the timer fires, in seconds
         target: self, // The object to which to send the message specified by aSelector when the timer fires
         selector: #selector(update), // The message to send to target when the timer fires
         userInfo: nil, // Data to pass to target when the timer fires
         repeats: true // A Boolean value indicating whether the timer should repeatedly reschedule itself or not
      ) // Create a new timer with a time interval of 1 second, a target of `self`, and a selector of `update`
      RunLoop.main.add(
         timer, // The timer to add to the run loop
         forMode: RunLoop.Mode.common // The run loop mode in which to add the timer
      ) // Add the timer to the main run loop with a mode of `RunLoop.Mode.common`
      return self // Return `self`
   }
   /**
    * Stop the timer
    * - Description: This method stops the timer, effectively halting the
    *                countdown process. It is typically called when the OTP
    *                is no longer needed or when a new OTP is about to be
    *                generated.
    * - Fixme: ⚠️️ add some doc regarding sideeffects with timer etc
    */
   public func stop() {
      timer?.invalidate() // Stop the timer if it is currently running
      timer = nil // Set the timer to `nil` to release the reference to it
   }
   /**
    * Update
    * - Description: This method is called by the timer at each interval
    *                defined in the `start` method. It triggers the
    *                `onChange` closure, allowing the timer to perform any
    *                actions that have been set when the timer was
    *                initialized or modified.
    */
   @objc fileprivate func update() {
      onChange(self) // Call the `onChange` closure with `self` as the argument
   }
}
/**
 * Helper
 */
extension OTPTimer {
   /**
    * We use Double since this updates UI in most cases
    * - Description: This method calculates the progress of the current OTP
    *                period as a percentage. It determines how much time has
    *                elapsed in the current OTP period relative to the total
    *                period duration, providing a visual representation of
    *                the time remaining before the OTP expires.
    * - Parameters:
    *   - date: The time to start from
    *   - period: The amount of time (30 / 60sec) etc
    * - Returns: 0 - 1
    */
   public static func progressForDate(date: Date, period: Double) -> CGFloat {
      let remainder: Double = timeIntervalRemainingForDate(
         date: date, // The date for which to calculate the remaining time interval
         period: period // The time period for which the OTP is valid
      )
      return 1 - CGFloat(remainder / period) // Calculate the progress of the timer as a value between 0 and 1
   }
   /**
    * Between zero and period
    * - Description: Calculates the remaining time interval before the current
    *                period of the OTP expires. This is used to determine how
    *                much time is left before the OTP needs to be refreshed.
    * - Parameters:
    *   - date: The time to start from
    *   - period: The amount of time (30 / 60sec) etc
    */
   fileprivate static func timeIntervalRemainingForDate(date: Date, period: Double) -> Double {
      let remainder: TimeInterval = date.timeIntervalSince1970.truncatingRemainder(dividingBy: period)
      return period - remainder // Calculate the time interval remaining for the specified date and period
   }
}
/**
 * Const / type
 */
extension OTPTimer {
   /**
    * Callback signature for the ticker
    * - Description: Defines the signature for the callback function that
    *                is invoked when the timer updates. This callback is
    *                used to perform actions in response to each tick of the
    *                timer.
    * - Parameter otpTimer: The `OTPTimer` object that is calling the
    *                callback.
    */
   public typealias OTPTimerCallback = (_ otpTimer: OTPTimer) -> Void
   /**
    * This is the default callback function for the OTP timer.
    * - Description: If no custom callback function is provided when the OTP
    *                timer is initialized or modified, this default function
    *                will be called instead. It simply prints "Default onChange"
    *                to the console.
    * - Note: If you forget to add event handler, this will be called
    */
   fileprivate static let defaultOnChange: OTPTimerCallback = { (_: OTPTimer) in
      Swift.print("Default onChange")
   }
}
