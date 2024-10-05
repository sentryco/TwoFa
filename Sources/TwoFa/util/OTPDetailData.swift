import Foundation
/**
 * Used as "data-model" for reading "otp-details"
 * - Description: This enum represents the different data fields of an OTP (One-Time Password) account. Each case corresponds to a specific attribute of the OTP account, such as the name, issuer, secret key, encoding type, OTP type, algorithm, number of digits, and the validity period of the OTP code.
 * - Remark: Needs to be here because it uses SecLib calls to read values etc
 * - Note: Alternative name: `OTPDetailData`, `OTPDataModel`
 */
public enum OTPData: CaseIterable {
   // basic
   /**
    * Represents the name of the OTP account
    * - Description: The 'name' case represents the unique identifier for the OTP account, typically the user's name or an account alias that helps the user recognize the account associated with the OTP.
    */
   case name
   /**
    * Represents the issuer of the OTP account
    * - Description: The 'issuer' case represents the entity that provides and manages the OTP account. This is typically the service or organization that requires the OTP for authentication.
    */
   case issuer
   // info
   /**
    * Represents the secret key of the OTP account
    * - Description: The 'secret' case represents the secret key used in the OTP account. This key is a critical component of the OTP algorithm, as it is used to generate the one-time passwords that are unique to each user's account.
    */
   case secret
   /**
    * Represents the encoding type of the OTP account
    * - Description: The 'encoding' case represents the encoding type used for the OTP account. This could be either base32 or base64, which are commonly used encoding types for OTPs.
    */
   case encoding
   /**
    * Represents the type of the OTP account
    * - Description: The 'type' case represents the type of OTP account. This could be either TOTP (Time-Based One-Time Password) or HOTP (HMAC-Based One-Time Password), which are the two most common types of OTPs.
    */
   case type
   // advance
   /**
    * Represents the algorithm used for the OTP account
    * - Description: The 'algo' case represents the algorithm used for the OTP account. This could be SHA1, SHA256, or SHA512, which are commonly used algorithms for OTPs.
    */
   case algo
   /**
    * Represents the number of digits in the OTP code
    * - Description: The 'digits' case represents the number of digits that will be present in the OTP code. This number typically ranges from 6 to 8 digits, providing a balance between security and ease of use for the user.
    */
   case digits
   /**
    * Represents the time period for which the OTP code is valid
    * - Description: The 'period' case represents the time period for which the OTP code is valid. This is typically a fixed interval of time (e.g., 30 or 60 seconds) during which the generated OTP code can be used for authentication.
    */
   case period
}
/**
 * Const
 */
extension OTPData {
   // Represents the title for the section containing basic OTP account information
   public static let infoTitle: String = "Info"
   // Represents the title for the section containing advanced OTP account settings
   public static let advanceTitle: String = "Advance"
}
/**
 * Getters
 */
extension OTPData {
   /**
    * Returns the title of the OTP data type.
    * - Abstract: This property returns a string that represents the title of the OTP data type. The title is used to identify the type of OTP data being referred to.
    * - Description: This property provides a human-readable title for each OTP data type. The title is used in the user interface to label the corresponding data field for the OTP account.
    * - Returns: A string representing the title of the OTP data type.
    */
   public var title: String {
      switch self {
      case .name: // The name of the OTP account
         return "Name"
      case .issuer: // The issuer of the OTP account
         return "Issuer"
      case .secret: // The secret key of the OTP account
         return "Secret"
      case .encoding: // The encoding type of the OTP account
         return "Encoding"
      case .type: // The type of the OTP account
         return "Type"
      case .algo: // The algorithm used for the OTP account
         return "Algorithm"
      case .digits: // The number of digits in the OTP code
         return "Digits"
      case .period: // The time period for which the OTP code is valid
         return "Period"
      }
   }
   /**
    * value (The otpAccount value)
    * - Description: This function retrieves the value of the OTPAccount instance based on the OTPData type. The value returned is a string representation of the corresponding property of the OTPAccount instance.
    * - Parameter otpAccount: The OTPAccount instance for which the value is being retrieved.
    */
   public func getValue(otpAccount: OTPAccount) -> String? {
      switch self {
      case .name: // john@gmail.com
         return otpAccount.name
      case .issuer: // dropbox.com etc
         return otpAccount.issuer
      case .secret: // 24834HSfdfeHS
         return otpAccount.otp.secret.base64EncodedString()
      case .encoding: // encoded [on/off],
         return String(describing: otpAccount.otp.secret.encodingType)
      case .type: // TOTP (Time based) / HTOP (Counter based)
         return otpAccount.generatorType.stringValue
      case .algo: // sha1
         return otpAccount.otp.algo.rawValue.uppercased()
      case .digits: // 6/8 etc,
         return String(otpAccount.otp.digits)
      case .period: // 0,30,60 etc
         return String(otpAccount.otp.period)
      }
   }
}
