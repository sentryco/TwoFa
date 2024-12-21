import SwiftUI
/**
 * - Description: The `OTPArc` struct provides a visual representation of an 
 *               OTP (One-Time Password) countdown, utilizing a circular 
 *               progress indicator to depict the remaining time until the 
 *               next OTP is generated. This view integrates with an 
 *               `OTPAccount` to fetch necessary data and uses an `OTPTimer` 
 *               for accurate timing updates.
 * - Note: Preview is in the OTPRowView` and `GraphView+Preview`
 * - Fixme: ⚠️️ Make a preview
 */
public struct OTPArc: View {
   /**
    * - Abstract: An optional instance of the `OTPAccount` class, 
    *             representing the account associated with the 
    *             current context.
    * - Description: The `OTPAccount` class encapsulates information 
    *                about a user's account, such as the account name, 
    *                secret key, and other relevant details required 
    *                for generating and verifying one-time passwords 
    *                (OTPs).
    * - Note: If the value of `account` is non-nil, it means that an 
    *         account has been successfully retrieved and can be used 
    *         for OTP-related operations. If the value is nil, it 
    *         indicates that no account information is available in 
    *         the current context.
    */
   internal let account: OTPAccount?
   /**
    * Timer object
    * - Abstract: Callback timer (Updates countdown, graph and factor)
    * - Description: This property holds an instance of `OTPTimer`, 
    *               which is used to manage the timing aspects of 
    *               the OTP generation process. It triggers periodic 
    *               updates that are essential for recalculating and 
    *               displaying the remaining time until the next OTP 
    *               is generated.
    */
   internal var otpTimer: OTPTimer?
   /**
    * The state manager for tracking progress.
    * - Description: This property is an instance of `ProgressStateManager`, 
    *               which is responsible for managing the state of 
    *               progress within the OTPArc view. It allows for 
    *               the observation of state changes and updates the 
    *               UI accordingly.
    * - Note: ObservedObject works like a binding for StateObject
    * - Fixme: ⚠️️ Was @ObservedObject, but was probably wrong, double check later
    * - Fixme: ⚠️️ Maybe ask copilot here because if we use stateobject we get: "Accessing StateObject's object without being installed on a View. This will create a new instance each time."
    */
   @ObservedObject internal var stateManager: ProgressStateManager = .init()
   /**
    * Styling
    */
   internal let graphStyle: GraphStyle
   /**
    * Init
    * - Description: Initializes an `OTPArc` view with an optional 
    *               `OTPAccount`. If an account is provided, it 
    *               initializes an `OTPTimer` to manage OTP 
    *               generation timing.
    * - Parameters:
    *   - account: The data model to generate timer from etc
    *   - graphStyle: The style of the graph.
    */
   public init(account: OTPAccount?, graphStyle: GraphStyle = .defaultGraphStyle) {
      self.account = account
      self.graphStyle = graphStyle
      self.otpTimer = initOTPTimer() // Init timer based on one-time-code config
   }
}
