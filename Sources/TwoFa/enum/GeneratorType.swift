import Foundation
/**
 * The type of generator to use for generating one-time passwords.
 * - Description: The `GeneratorType` enum defines the type of generator to use for generating one-time passwords. It includes `totp` for Time-based One-Time Password and `htop` for HMAC-based One-Time Password. The `htop` generator also requires an initial counter value.
 * - Remark: `totp` stands for Time-based One-Time Password, which generates a new password at fixed time intervals.
 * - Remark: `htop` stands for HMAC-based One-Time Password, which generates a new password based on a counter value.
 * - Remark: The `counter` parameter in `htop` specifies the initial counter value to use for generating passwords.
 * - Remark: The `counter` in `htop` is a moving factor that changes with each password generation. It starts with the initial value provided and increments by one each time a new password is generated. This ensures that each password is unique and cannot be reused, providing an additional layer of security.
 */
public enum GeneratorType {
   /**
    * A case for Time-based One-Time Password generator.
    * - Description: TOTP stands for Time-based One-Time Password. It generates a new password at fixed time intervals, typically every 30 seconds. This method is based on the current time, which means that the generated password changes every interval and cannot be used again, providing a high level of security.
    */
   case totp
   /**
    * A case for HMAC-based One-Time Password generator with an initial counter value.
    * - Description: HOTP stands for HMAC-based One-Time Password. It generates a new password based on a counter value. The counter starts with an initial value and increments by one each time a new password is generated. This ensures that each password is unique and cannot be reused, providing a high level of security.
    * - Parameter counter: The initial counter value for the generator.
    */
   case htop(_ counter: Int)
}
/**
 * Ext 
 */
extension GeneratorType {
   /**
    * The string value of the given algorithm, used for parsing URL's typically returns "TOTP", "HTOP"
    * - Description: This computed property returns a string representation of the generator type. For TOTP, it returns "totp", and for HOTP, it returns "hotp". This is typically used for parsing URLs.
    * - Remark: We use `if case because == (equality sign)` doesn't work for enum
    * - Fixme: ⚠️️ maybe ask copilot for alternate way of writing this? or not?
    * - Fixme: ⚠️️ move strings to const etc
    */
   public var stringValue: String {
      if case .totp = self { // Check if the generator type is TOTP
         return "totp" // Return "totp" if the generator type is TOTP
      } else { // Otherwise, the generator type must be HOTP
         return "hotp" // Return "hotp" if the generator type is HOTP
      }
   }
   /**
    * A computed property that checks if the generator type is Time-based One-Time Password (TOTP).
    * - Description: This computed property returns a boolean value indicating whether the generator type is TOTP. If the generator type is TOTP, it returns true. Otherwise, it returns false. This is typically used to determine the type of generator for password generation.
    * - Remark: This is coded like this because "==" doesn't work with case etc
    * - Fixme: ⚠️️ maybe ask copilot for alternate way of writing this?
    */
   internal var isTimeBased: Bool {
      if case .totp = self { // Check if the generator type is TOTP
         return true // Return true if the generator type is TOTP
      } else { // Otherwise, the generator type must be HOTP
         return false // Return false if the generator type is HOTP
      }
   }
}
