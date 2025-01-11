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
   // ⚠️️ suggestio from o1
//   internal static func generate2<T>(otp: OTP, counter: UInt64, hashFunc: T.Type) throws -> String where T: HashFunction {
//       // Calculate the HMAC hash of the OTP and counter
//       let hashData = try hmac(
//           otp: otp, // The secret key used to generate the one-time password
//           counter: counter // The counter value used to generate the one-time password
//       )
//
//       // Perform dynamic truncation as per RFC 4226
//       guard let lastByte = hashData.last else {
//           throw OTPError.invalidHash // Handle the case where hashData is empty
//       }
//       let offset = Int(lastByte & 0x0f) // Get the offset from the low 4 bits of the last byte
//
//       // Ensure there are enough bytes to extract starting from the offset
//       guard hashData.count >= offset + 4 else {
//           throw OTPError.invalidHashLength // Handle insufficient hashData length
//       }
//
//       // Extract 4 bytes starting from the offset
//       let truncatedHashData = hashData.subdata(in: offset..<(offset + 4))
//       // Convert the 4 bytes into a UInt32 value
//       var truncatedHash = truncatedHashData.withUnsafeBytes { $0.load(as: UInt32.self) }
//       truncatedHash = UInt32(bigEndian: truncatedHash) & 0x7fffffff // Convert to big-endian and mask the most significant bit
//
//       // Calculate the truncated hash value as a value between 0 and 10^digits-1
//       let modulo = UInt32(pow(10, Float(otp.digits)))
//       truncatedHash = truncatedHash % modulo
//
//       // Format the truncated hash value as a string with leading zeros and return it
//       return String(
//           format: "%0*u", // The format string to use to format the truncated hash value
//           otp.digits,     // The number of digits to format the truncated hash value to
//           truncatedHash   // The truncated hash value to format
//       )
//   }
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
       // Start of Selection
       fileprivate static func hmac(otp: OTP, counter: UInt64) throws -> Data {
          var bigCounter = counter.bigEndian // Convert the counter to big-endian format
          // Initialize a new Data object with the counter value
          let counterData = Data(
             bytes: &bigCounter, // The counter value used to generate the one-time password
             count: MemoryLayout<UInt64>.size // The size of the counter value in bytes
          )
          
          // Generate an HMAC hash of the counter data using the secret key and specified hash function
          let key = SymmetricKey(data: otp.secret)
          
          // Use the algorithm to compute HMAC
          let hmacData = otp.algo.hmac(for: counterData, using: key)
          return hmacData
       }
       
}

extension Algorithm {
   func hmac(for data: Data, using key: SymmetricKey) -> Data {
      switch self {
      case .sha1:
         return Data(HMAC<Insecure.SHA1>.authenticationCode(for: data, using: key))
      case .sha256:
         return Data(HMAC<SHA256>.authenticationCode(for: data, using: key))
      case .sha512:
         return Data(HMAC<SHA512>.authenticationCode(for: data, using: key))
      }
   }
}
#endif
