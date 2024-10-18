#if canImport(CryptoKit)
import CryptoKit
import Foundation
/**
 * An object for generating time-based & HMAC-based one-time passwords
 * - Description: The `Generator` struct is responsible for creating one-time
 *                passwords (OTPs) that are either time-based (TOTP) or
 *                HMAC-based (HOTP). It provides a secure way to generate
 *                OTPs that are used for two-factor authentication, ensuring
 *                that each password is unique and valid only for a short
 *                period or single use.
 * - Fixme: ⚠️️ Has more modern code:
 *          https://github.com/lachlanbell/SwiftOTP/blob/master/SwiftOTP/Generator.swift
 */
public struct Generator {}
/**
 * Helper
 */
extension Generator {
   /**
    * Generate "HashFunction"
    * - Description: Generates a one-time password using the provided hash
    *                function. This method computes the HMAC of the counter
    *                value using the secret key from the OTP instance and then
    *                applies a dynamic truncation function to extract a portion
    *                of the HMAC result. The extracted value is then reduced
    *                to the desired number of digits to produce the final
    *                one-time password.
    * - Note: Has alternate hash code:
    *         https://github.com/lachlanbell/SwiftOTP/blob/master/SwiftOTP/Generator.swift
    * - Parameters:
    *   - otp: `One-Time-Password` instance
    *   - counter: Counter value (progressed period)
    *   - hashFunc: Time-based, HMAC-based
    */
   internal static func generate<T>(otp: OTP, counter: UInt64, hashFunc: T.Type) throws -> String where T: HashFunction {
      let hashData: Data = try hmac(
         otp: otp, // The secret key used to generate the one-time password
         counter: counter // The counter value used to generate the one-time password
      ) // Calculate the HMAC-SHA256 hash of the OTP and counter
      // Get the last 4 bytes of the hash and convert them to a UInt32 value
      var truncatedHash: UInt32 = hashData.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> UInt32 in
         let offset: UInt8 = ptr.last! & 0x0f // Get the offset of the last byte
         // Get a pointer to the last 4 bytes of the hash
         let truncatedHashPtr: UnsafeRawPointer = ptr.baseAddress! + Int(offset)
         // Convert the last 4 bytes of the hash to a UInt32 value
         return truncatedHashPtr.bindMemory(
            to: UInt32.self, // The type of the memory to bind to
            capacity: 1 // The capacity of the memory to bind to
         ).pointee // Get a pointer to the first byte of the memory
      }
      truncatedHash = UInt32(bigEndian: truncatedHash) // Convert the UInt32 value to big-endian format
      truncatedHash &= 0x7fffffff // Mask the most significant bit of the UInt32 value
      // Calculate the truncated hash value as a value between 0 and 10^digits-1
      truncatedHash = truncatedHash % UInt32(pow(10, Float(otp.digits)))
      // Format the truncated hash value as a string with leading zeros and return it
      return String(
         format: "%0*u", // The format string to use to format the truncated hash value
         otp.digits, // The number of digits to format the truncated hash value to
         truncatedHash // The truncated hash value to format
      )
   }
}
/**
 * hmac
 */
extension Generator {
   /**
    * hmac
    * - Description: This method generates an HMAC (Hash-based Message 
    *                Authentication Code) using the secret key from the OTP 
    *                instance and the provided counter value. The HMAC is a 
    *                specific type of message authentication code (MAC) 
    *                involving a cryptographic hash function and a secret 
    *                cryptographic key. It is used as a means of verifying 
    *                both the data integrity and the authenticity of a message. 
    *                The method selects the appropriate HMAC algorithm based on 
    *                the algorithm specified in the OTP instance (SHA1, SHA256, 
    *                or SHA512).
    * - Note: More hmac code: https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/Crypto.swift
    * - Parameters:
    *   - otp: The `OneTimePassword` instance
    *   - counter: Counter value (progressed period)
    */
   fileprivate static func hmac(otp: OTP, counter: UInt64) throws -> Data {
      var bigCounter: UInt64 = counter.bigEndian // Convert the counter to big-endian format
      // Convert the counter to a data object
      let counterData: Data = .init( // Initialize a new Data object with the counter value
         bytes: &bigCounter, // The counter value used to generate the one-time password
         count: MemoryLayout<UInt64>.size // The size of the counter value in bytes
      )
      switch otp.algo { // Choose the appropriate HMAC algorithm based on the OTP algorithm
      case .sha1: // SHA1 hash function (dep.recated due to security vulnerabilities)
         // Generate an HMAC-SHA1 hash of the counter data using the secret key
         // Returns a Data object containing the HMAC-SHA1 hash of the counter data using the secret key
         // Note: SHA1 is no longer considered secure for cryptographic purposes and should be used with caution.
         // Generate an HMAC-SHA1 hash of the counter data using the secret key
         // Create a Data instance containing the HMAC-SHA1 hash
         return Data(
            HMAC<Insecure.SHA1>.authenticationCode( // Generate an HMAC using SHA1 which is considered insecure for cryptographic purposes
               for: counterData, // The counter value used to generate the one-time password
               using: SymmetricKey(data: otp.secret) // The secret key used to generate the one-time password
            )
         )
      case .sha256: // Case for generating HMAC using SHA256 algorithm
         // Generate an HMAC-SHA256 hash of the counter data using the secret key
         // Returns a Data object containing the HMAC-SHA256 hash of the counter data using the secret key
         return Data(
            HMAC<SHA256>.authenticationCode( // Generate an HMAC using SHA256
               for: counterData, // The counter value used to generate the one-time password
               using: SymmetricKey(data: otp.secret) // The secret key used to generate the one-time password
            )
         )
      case .sha512: // Generate an HMAC-SHA512 hash of the counter data using the secret key
         // Generate an HMAC-SHA512 hash of the counter data using the secret key
         // Returns a Data object containing the HMAC-SHA512 hash of the counter data using the secret key
         return Data(
            HMAC<SHA512>.authenticationCode( // Generate an HMAC using SHA512
               for: counterData, // The counter value used to generate the one-time password
               using: SymmetricKey(data: otp.secret) // The secret key used to generate the one-time password
            )
         )
      }
   }
}
#endif
