#if canImport(CryptoKit)
import CryptoKit
import Foundation
/**
 * Generate
 * - Description: This extension provides methods to generate a One-Time Password (OTP) based on the current date or a specified counter value. It uses the secret key, period, number of digits, and hashing algorithm specified in the OTP instance to generate the OTP.
 */
extension OTP {
   /**
    * Create OTP value from OTP-config and date
    * - Description: This function generates a One-Time Password (OTP) based on the current date. The OTP is generated using the secret key, period, number of digits, and hashing algorithm specified in the OTP instance. The date parameter is used to calculate the counter value for the OTP generation. By default, the current date and time is used.
    * - Returns: I.E: 935170, 172681 etc (One time code string or error)
    * - Parameter date: The date for which you want to create the "OneTimePassword" default is now (Date object to generate password for)
    */
   public func generate(date: Date = .init()) throws -> String {
      let counter: UInt64 = .init(date.timeIntervalSince1970 / self.period).bigEndian // Calculate the counter value as the number of periods since the Unix epoch, converted to big-endian format
      return try generate(counter: counter) // Generate an OTP for the specified counter value using the `generate` method and return it
   }
   /**
    * One time code string, nil if error
    * - Description: This function generates a One-Time Password (OTP) based on the number of seconds elapsed since the Unix epoch (January 1, 1970, at 00:00:00 UTC). It calculates the counter value by dividing the provided time by the period of the OTP instance and then generates the OTP using the specified hashing algorithm.
    * - parameter secondsPast1970: Time since Unix epoch (01 Jan 1970 00:00 UTC)
    */
   public func generate(secondsPast1970: Int) throws -> String {
      guard hasValidTime(time: secondsPast1970) else {
         // Throw an error indicating that the provided time is invalid
         throw OTPError.invalidTime
      } // Check if the specified time is valid
      let counter = Int(floor(Double(secondsPast1970) / Double(self.period))) // Calculate the counter value as the number of periods since the Unix epoch
      return try generate(counter: UInt64(counter)) // Generate an OTP for the specified counter value using the `generate` method and return it
   }
   /**
    * Generate `one-time-code` string from counter value
    * - Abstract: This is basically how you generate HTOP
    * - Description: This function generates a One-Time Password (OTP) based on a given counter value. The counter value is a moving factor that changes with each password generation. It starts with an initial value and increments by one each time a new password is generated. This ensures that each password is unique and cannot be reused, providing a high level of security.
    * - parameter counter: Counter value (progressed period)
    */
   public func generate(counter: UInt64) throws -> String {
      switch self.algo { // Choose the appropriate HMAC algorithm based on the OTP algorithm
      case .sha1: // If the OTP algorithm is SHA1
         // Generate an HMAC-SHA1 hash of the OTP and counter using the `generate` method of the `Generator` class
         try Generator.generate(
            otp: self, // The current OTP instance
            counter: counter, // The counter value calculated based on the current time
            hashFunc: Insecure.SHA1.self // The hash function to use, in this case, SHA1
         )
      case .sha256: // If the OTP algorithm is SHA256
         // Generate an HMAC-SHA256 hash of the OTP and counter using the `generate` method
         try Generator.generate(
            otp: self, // Pass the current OTP instance
            counter: counter, // Pass the calculated counter value
            hashFunc: SHA256.self // Use SHA256 as the hash function
         )
      case .sha512: // If the OTP algorithm is SHA512
         // Generate an HMAC-SHA512 hash of the OTP and counter using the `generate` method
         try Generator.generate(
            otp: self, // Pass the current OTP instance
            counter: counter, // Pass the calculated counter value
            hashFunc: SHA512.self // Use SHA512 as the hash function
         )
      }
   }
}
/**
 * Private helpers
 */
extension OTP {
   /**
    * Verify that the time integer is positive
    * - Description: This method validates that the number of digits specified for the OTP falls within the accepted range. The OTP standard requires the number of digits to be between 6 and 8 inclusive to ensure a balance between security and usability.
    * - parameter digit: Number of allowed digits in the OTP
    */
   internal func hasValidDigit(digit: Int) -> Bool {
      (6...8).contains(digit) // Must be between 6 and 8
   }
   /**
    * Verify that time integer is positive
    * - Description: This method checks if the provided time, which is the number of seconds since the Unix epoch (01 Jan 1970 00:00 UTC), is a positive integer. This is important because a negative time value is not valid in this context and would lead to incorrect OTP generation.
    * - parameter time: Time since Unix epoch (01 Jan 1970 00:00 UTC)
    */
   internal func hasValidTime(time: Int) -> Bool {
      time > 0 // Time must not be negative
   }
}
#endif
