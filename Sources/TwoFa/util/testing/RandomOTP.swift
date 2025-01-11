#if DEBUG
import Foundation
import CryptoKit
// import Logger
import MockGen
/**
 * Used for Unit-testing
 * - Description: This class provides methods to generate random OTP 
 *                (One-Time Password) account data for testing purposes. It 
 *                includes functionality to create random OTP account URLs and 
 *                OTPAccount instances with various properties such as name, 
 *                issuer, and secret. This is useful for unit tests that 
 *                require OTP data but do not need to rely on fixed test data.
 * - Fixme: ⚠️️⚠️️⚠️️ move to testing scope?, move it out? do we use it anywhere else?  👈 yes move it to test scope, make sure other tests outside this framework run after etc
 * - Remark: I guess we keep it here because other libs use it for their tests?
 */
public class RandomOTP {
   /**
    * Random otp url str
    * - Description: This method generates a random OTP (One-Time Password)
    *                account URL string for testing purposes. The URL string is
    *                constructed with a random first name, brand name, and OTP
    *                account details. If any of these random values cannot be
    *                generated, the method returns nil.
    * ## Examples:
    * let randomOTP: String = RandomOTP.randomOTPAccountURLStr ?? "otpauth://hotp/test?secret=6UAOpz+x3dsNrQ==&algorithm=SHA512&digits=6&counter=1"
    */
   internal static var randomOTPAccountURLStr: String? {
      // Attempt to generate a random first name, brand name, email, and OTP account; return nil if any step fails
      guard
         // Generate a random first name
         let firstName: String = MockGen.randomFirstName,
         // Generate a random brand name
         let brand: String = MockGen.randomBrand,
         // Generate an email using the random first name and brand
         let name: String = MockGen.getEmail(name: firstName, brand: brand),
         // Create a random OTP account using the generated name and brand
         let otpAccount: OTPAccount = RandomOTP.randomOTPAccount(name: name, issuer: brand)
      else {
         return nil
      }
      // Return the absolute URL string of the generated OTP account
      return otpAccount.absoluteURL.absoluteString
   }
   /**
    * OTP-mock-generator
    * - Description: This method generates a random OTPAccount instance for
    *                testing purposes. It takes a name and issuer as parameters
    *                and creates an OTPAccount with a random secret, period,
    *                algorithm, digit count, and generator type. The method
    *                returns an optional OTPAccount, which is nil if any part of
    *                the OTPAccount creation fails.
    * - Fixme: ⚠️️ Add img-url to the method
    * - Parameters:
    *   - name: email or name
    *   - issuer: brand name or website url
    * - Returns: otp-url (can be parsed to OTPAccount / OTP etc)
    */
   internal static func randomOTPAccount(name: String, issuer: String) -> OTPAccount? {
       // Generate a random secret key between 8 and 16 bytes long
       guard let secret = randomSecret(min: 8, max: 16) else {
           return nil // Return nil if the secret key cannot be generated
       }
       
       // Generate random OTP parameters
       let period = [30.0, 60.0].randomElement()!
       let algoType = [Algorithm.sha1, .sha256, .sha512].randomElement()!
       let digitCount = [6, 8].randomElement()!
       let generatorType: GeneratorType = Bool.random() ? .totp : .htop(1)
       
       // Create a new one-time password using the generated parameters
       guard let otp = try? OTP(
           secret: secret, // The secret key used to generate the one-time password
           period: period, // The time period for the one-time password
           digits: digitCount, // The number of digits in the one-time password
           algo: algoType // The hash algorithm to use for the one-time password
       ) else {
           return nil // Return nil if the OTP cannot be generated
       }
       
       // Create and return a new OTP account
       return OTPAccount(
           name: name, // The name of the account
           issuer: issuer, // The issuer of the account
           imageURL: nil, // The URL of an image associated with the account (optional)
           otp: otp, // The one-time password
           generatorType: generatorType // The type of one-time password generator to use
       )
   }
}
/**
 * OTPHelpers
 * - Description: Provides utility functions for generating random OTP
 *                (One-Time Password) accounts and secret keys for testing
 *                purposes.
 */
extension RandomOTP {
   /**
    * Generate a random secret key with a length between `min` and `max` bytes
    * - Description: This function generates a random secret key within the
    *                specified byte range. The secret key is essential for
    *                creating secure one-time passwords (OTPs) used in two-factor
    *                authentication systems. The randomness ensures that each
    *                secret key is unique and unpredictable, enhancing the
    *                security of the OTP mechanism.
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
    * - Description: This function generates a random secret key of a specified
    *                length. The secret key is used in the generation of one-time
    *                passwords for TOTP and HOTP authentication. The function
    *                returns a `Data` object containing the generated secret key,
    *                or `nil` if the key cannot be generated.
    * - Note: This can be done with `SecRandomCopyBytes` as well. but the idea
    *         here is to use base64 because it works with the otp secret.
    *         SecRandomCopyBytes might also work. but that has not been tested
    *         yet. worth a test
    * - Fixme: ⚠️️ this is the same as in mockgen so move it there?
    * - Parameters:
    *   - length: The length of the secret key in bytes.
    * - Returns: A `Data` object containing the generated secret key, or `nil` if the key cannot be generated.
    */
   fileprivate static func randomSecret(length: Int) -> Data? {
      // Create a new symmetric key with the specified length in bits
      // Since 'length' is in bytes, we multiply by 8 to get bits
      let symKey = SymmetricKey(size: .init(bitCount: length * 8))
      // Convert the symmetric key to a Data object
      let secretData = symKey.withUnsafeBytes { Data($0) }
      return secretData // Return the generated secret key as a Data object
   }
}
#endif
