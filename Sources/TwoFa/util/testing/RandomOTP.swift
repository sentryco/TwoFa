#if DEBUG
import Foundation
import CryptoKit
import Logger
import MockGen
/**
 * Used for Unit-testing
 * - Description: This class provides methods to generate random OTP (One-Time Password) account data for testing purposes. It includes functionality to create random OTP account URLs and OTPAccount instances with various properties such as name, issuer, and secret. This is useful for unit tests that require OTP data but do not need to rely on fixed test data.
 * - Fixme: ⚠️️⚠️️⚠️️ move to testing scope?, move it out? do we use it anywhere else?  👈 yes move it to test scope, make sure other tests outside this framework run after etc
 * - Remark: I guess we keep it here because other libs use it for their tests?
 */
public class RandomOTP {
   /**
    * Random otp url str
    * - Description: This method generates a random OTP (One-Time Password) account URL string for testing purposes. The URL string is constructed with a random first name, brand name, and OTP account details. If any of these random values cannot be generated, the method returns nil.
    * ## Examples:
    * let randomOTP: String = RandomOTP.randomOTPAccountURLStr ?? "otpauth://hotp/test?secret=6UAOpz+x3dsNrQ==&algorithm=SHA512&digits=6&counter=1"
    */
   internal static var randomOTPAccountURLStr: String? {
      // Attempt to generate a random first name, return nil if unsuccessful
      guard let firstName: String = MockGen.randomFirstName else { return nil }
      // Attempt to generate a random brand name, return nil if unsuccessful
      guard let brand: String = MockGen.randomBrand  else { return nil }
      // Attempt to generate an email using the random first name and brand, return nil if unsuccessful
      guard let name: String = MockGen.getEmail(name: firstName, brand: brand) else { return nil }
      // Attempt to create a random OTP account using the generated name and brand, return nil if unsuccessful
      guard let otpAccount: OTPAccount = RandomOTP.randomOTPAccount(name: name, issuer: brand) else { return nil }
      // Return the absolute URL string of the generated OTP account
      return otpAccount.absoluteURL.absoluteString
   }
   /**
    * OTP-mock-generator
    * - Description: This method generates a random OTPAccount instance for testing purposes. It takes a name and issuer as parameters and creates an OTPAccount with a random secret, period, algorithm, digit count, and generator type. The method returns an optional OTPAccount, which is nil if any part of the OTPAccount creation fails.
    * - Fixme: ⚠️️ Add img-url to the method
    * - Parameters:
    *   - name: email or name
    *   - issuer: brand name or website url
    * - Returns: otp-url (can be parsed to OTPAccount / OTP etc)
    */
   internal static func randomOTPAccount(name: String, issuer: String) -> OTPAccount? {
      // Generate a random secret key between 8 and 16 bytes long
      guard let secret: Data = randomSecret(min: 8, max: 16) else {
        //  Logger.warn("\(Trace.trace()) no secret", tag: .security) // Log a warning if the secret key cannot be generated
         return nil // Return nil if the secret key cannot be generated
      }
      // Choose a random time period of either 30 or 60 seconds
      let period: Double = Bool.random() ? 30 : 60
      // Choose a random hash algorithm from the SHA family
      let algoType: Algorithm = [.sha512, .sha256, .sha1].randomElement() ?? .sha1
      // Choose a random number of digits for the one-time password, either 6 or 8
      let digitCount: Int = Bool.random() ? 6 : 8
      // Choose a random generator type, either TOTP or HOTP with an initial counter value of 1
      let generatorType: GeneratorType = Bool.random() ? .totp : .htop(1)
      // Create a new one-time password using the generated secret key, time period, hash algorithm, and number of digits
      guard let otp: OTP = try? .init(
         secret: secret, // The secret key used to generate the one-time password
         period: period, // The time period for the one-time password
         digits: digitCount, // The number of digits in the one-time password
         algo: algoType // The hash algorithm to use for the one-time password
      ) else {
         // Logger.warn("\(Trace.trace()) no otp", tag: .security) // Log a warning if the one-time password cannot be generated
         return nil
      }
      // Create a new OTP account with the generated name, issuer, image URL, one-time password, and generator type
      let otpAccount: OTPAccount = .init(
         name: name, // The name of the account for which the one-time password is being generated
         issuer: issuer, // The issuer of the account for which the one-time password is being generated
         imageURL: nil, // The URL of an image associated with the account (optional)
         otp: otp, // The secret key used to generate the one-time password
         generatorType: generatorType // The type of one-time password generator to use
      )
      // Return the new OTP account
      return otpAccount
   }
}
/**
 * OTPHelpers
 * Provides utility functions for generating random OTP (One-Time Password) accounts and secret keys for testing purposes.
 */
extension RandomOTP {
   /**
    * Generate a random secret key with a length between `min` and `max` bytes
    * - Description: This function generates a random secret key within the specified byte range. The secret key is essential for creating secure one-time passwords (OTPs) used in two-factor authentication systems. The randomness ensures that each secret key is unique and unpredictable, enhancing the security of the OTP mechanism.
    * - Parameters:
    *   - min: The minimum length of the secret key in bytes.
    *   - max: The maximum length of the secret key in bytes.
    * - Returns: A `Data` object containing the generated secret key, or `nil` if the key cannot be generated.
    */
   fileprivate static func randomSecret(min: Int = 8, max: Int = 44) -> Data? {
      let length = Int.random(in: min..<max) // Directly choose a random length between `min` and `max`
      return randomSecret(length: length) // Generate a random secret key with the chosen length
   }
   /**
    * This function generates a random one-time password secret key with a length of 256 bits (32 bytes).
    * - Abstract: The secret key is used to generate one-time passwords for TOTP and HOTP authentication.
    * - Description: This function generates a random secret key of a specified length. The secret key is used in the generation of one-time passwords for TOTP and HOTP authentication. The function returns a `Data` object containing the generated secret key, or `nil` if the key cannot be generated.
    * - Note: This can be done with `SecRandomCopyBytes` as well. but the idea here is to use base64 because it works with the otp secret. SecRandomCopyBytes might also work. but that has not been tested yet. worth a test
    * - Fixme: ⚠️️ this is the same as in mockgen so move it there?
    * - Parameters:
    *   - length: The length of the secret key in bytes.
    * - Returns: A `Data` object containing the generated secret key, or `nil` if the key cannot be generated.
    */
   fileprivate static func randomSecret(length: Int) -> Data? {
      let symKeySalt = SymmetricKey(size: .bits256) // Create a new symmetric key with a size of 256 bits (32 bytes)
      let salt: Data = symKeySalt.withUnsafeBytes { Data($0) } // Convert the symmetric key to a Data object
      let secret: String = salt.base64EncodedString() // Encode the Data object as a base64 string
      let range: String = { // Limit the secret to the desired length
         // Get the start index of the secret string
         let start: String.Index = secret.index(secret.startIndex, offsetBy: 0)
         // Get the end index of the secret string
         let end: String.Index = secret.index(secret.startIndex, offsetBy: length)
         // Return the substring of the secret string between the start and end indices
         return String(secret[start..<end])
      }()
      // Convert the substring to a base64-encoded Data object and encode it as a string
      let base64Range: String = Data(range.utf8).base64EncodedString()
      // Convert the base64-encoded string to a Data object
      let data: Data? = .init(base64Encoded: base64Range)
      return data // Return the generated secret key as a Data object
   }
}
#endif
