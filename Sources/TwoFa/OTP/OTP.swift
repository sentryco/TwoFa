#if canImport(CryptoKit)
import CryptoKit
import Foundation
/**
 * OneTimePassword - OTP
 * - Description: The OTP struct represents a One-Time Password, a password that is valid for only one login session or transaction. It is commonly used in two-factor authentication systems to provide an additional layer of security beyond just a username and password. The OTP struct contains the secret key, the period for which the OTP is valid, the number of digits in the OTP, and the hashing algorithm used to generate the OTP.
 * - Note: A one-time password generator is a security tool used to generate a unique password that can only be used once. The purpose of a one-time password generator is to provide an additional layer of security to user accounts by requiring a new password for each login attempt. This helps to prevent unauthorized access to user accounts, even if the password is compromised. One-time password generators are commonly used in two-factor authentication (2FA) systems, where the user is required to provide both a password and a one-time password to access their account. This helps to ensure that only authorized users are able to access sensitive information or perform critical actions.
 * - Remark: `GeneratorType` is in `OTPAccount`
 */
public struct OTP {
   /**
    * This needs to be data, because there are many types to embed the data, base32, base64 etc etc ASCII etc (Secret key data)
    * - Description: The secret key is a unique piece of data that is used to generate the OTP. It is known only to the user and the system, and it is used in the OTP generation algorithm to create a unique and unpredictable OTP each time.
    * - Note: Access the secret with: `otp.secret.base64EncodedString()`
    * - Note: Access encoding type via `orp.secret.encodingType`
    */
   public let secret: Data
   /**
    * 30sec or 60sec etc
    * - Description: The period defines the length of time for which a Time-based One-Time Password (TOTP) is valid. After this time, a new OTP will be generated. The period is typically set to 30 seconds, aligning with the common TOTP standard.
    * - Note: Access this via: `String(otp.period)`
    */
   public let period: TimeInterval
   /**
    * Digits "must" be between 6 and 8 inclusive (Number of digits for generated string in range 6...8, defaults to 6)
    * - Description: The digits property specifies the length of the OTP. It must be within the range of 6 to 8 characters to conform to common standards and ensure a balance between security and usability.
    * - Note: Access this via: `String(otp.digits)`
    */
   public let digits: Int
   /**
    * The hashing algorithm to use of type OTPAlgorithm, defaults to SHA-1
    * - Description: The 'algo' property represents the cryptographic hash function used to generate the OTP. It determines how the secret key is transformed into a one-time password. Supported algorithms include SHA-1, SHA-256, and SHA-512, with SHA-1 being the least secure and SHA-512 being the most secure.
    * - Note: Access the type via: `otp.algo.rawValue.uppercased()`
    */
   public let algo: Algorithm
   /**
    * Initialise counter-based one time password object
    * - Description: Initializes a counter-based one-time password (OTP) object with a secret key, period of validity, number of digits, and a hashing algorithm. This OTP object can be used to generate passwords that are valid for a single use within the specified time frame, providing an additional layer of security for authentication processes.
    * - Remark: Digits "must" be between 6 and 8 inclusive
    * ## Examples:
    * .init(period: TimeInterval(30), digits: 6, secret: "6UAOpz+x3dsNrQ==")
    * - Parameters:
    *   - period: Interval it refreshes: 30secs, 60secs etc
    *   - digits: Number of digits of the output OneTimePassword: 6 (Number of digits for generated string in range 6...8, defaults to 6)
    *   - secret: The initial secret to setup OneTimePassword: "6UAOpz+x3dsNrQ==" (Secret key data)
    *   - algo: The hashing algorithm to use of type OTPAlgorithm, defaults to SHA-1
    */
   public init(secret: Data, period: TimeInterval = 30, digits: Int = 6, algo: Algorithm = .sha1) throws { /*, type: GeneratorType = .totp*/
      self.period = period // Assign the period parameter to the period property of the OTP instance
      self.digits = digits // Assign the digits parameter to the digits property of the OTP instance
      self.secret = secret // Assign the secret parameter to the secret property of the OTP instance
      self.algo = algo // Assign the algo parameter to the algo property of the OTP instance
      guard hasValidDigit(digit: digits) else { // Check if the digits property of the OTP instance is a valid digit
         throw OTPError.invalidDigits // If the digits property is not a valid digit, throw an OTPError.invalidDigits error
      } // throw error if digit count is not valid etc
   }
}
#endif
