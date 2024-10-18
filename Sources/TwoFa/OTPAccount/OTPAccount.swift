import Foundation
/**
 * An object for the metadata surrounding time-based & HMAC-based one-time passwords (A type that can represent one-time password objects)
 * - Remark: This object contains the metadata for an OTP
 * - Note: `generatorType Could also be named factor, moving factor see: https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/Crypto.swift
 */
public struct OTPAccount {
   /** 
    * The name associated with the OTP account, typically the user's account name.
    */
   public var name: String?
   /** 
    * The issuer of the OTP, usually the service or organization providing the account.
    */
   public var issuer: String?
   /** 
    * A URL string pointing to an image associated with the OTP account, such as a logo.
    */
   public var imageURL: String?
   /** 
    * The `One-Time Password` instance containing the current OTP value and associated properties.
    */
   public var otp: OTP
   /** 
    * The type of generator used to create the OTP, either time-based or HMAC-based.
    */
   public var generatorType: GeneratorType
   /**
    * Init password
    * - Description: This initializer creates an instance of OTPAccount with
    *                the provided parameters. The OTPAccount object represents
    *                an account that uses One-Time Passwords (OTP) for
    *                authentication. It includes the account name, issuer, an
    *                optional image URL, the OTP instance, and the type of OTP
    *                generator (time-based or HMAC-based).
    * - Fixme: ⚠️️ Add suport for image-url: image: URL(string: "https://www.images.com/image.png")!
    * - Fixme: ⚠️️ Throw error if parameters are not correct, with error that explaines why things are not correct etc. eventually present to user how to correct input data etc
    * - Parameters:
    *   - name: The account name
    *   - issuer: The issuer of the one-time code (Optional, but recommended)
    *   - imageURL: An image to associate with a given password, Not technically part of the Google Authenticator URI [spec](https://github.com/google/google-authenticator/wiki/Key-Uri-Format), but still useful and supported by other `URI` creators.
    *   - generatorType: The generator to be used for creating codes
    *   - otp: `One-Time-Password` Instance
    */
   public init(name: String? = nil, issuer: String? = nil, imageURL: String? = nil, otp: OTP, generatorType: GeneratorType) {
      self.name = name
      self.issuer = issuer
      self.imageURL = imageURL
      self.otp = otp
      self.generatorType = generatorType
   }
}
