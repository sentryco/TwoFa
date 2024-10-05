import Foundation
/**
 * Init
 * - Description: This extension provides initializers for the OTPAccount struct. It includes initializers that take a URL string or a URL object as input. These initializers parse the provided URL, which should be in the format of an otpauth URL, to extract the necessary information to set up an OTP account. This includes the account name, issuer, secret, algorithm, digits, and other optional parameters. An error is thrown if the provided URL is not a valid otpauth URL.
 */
extension OTPAccount {
   /**
    * init via string
    * - Description: This initializer creates an instance of OTPAccount using a URL string. The URL string should be in the format of an otpauth URL, which contains all the necessary information to set up an OTP account, such as the account name, issuer, secret, algorithm, digits, and other optional parameters. An error is thrown if the URL string is not a valid otpauth URL.
    * - Parameter urlStr: The URL string to initialize the OTPAccount from.
    */
   public init(urlStr: String) throws {
      guard let url: URL = .init(string: urlStr) else {
         // - Fixme: ⚠️️ probably add to OTPError? explore this
         throw NSError(domain: "Unable to make url", code: 0)
      }
      try self.init(url: url)
   }
   /**
    * Init with URL
    * - Description: This initializer creates an instance of OTPAccount using a URL. The URL should be in the format of an otpauth URL, which contains all the necessary information to set up an OTP account, such as the account name, issuer, secret, algorithm, digits, and other optional parameters. An error is thrown if the URL is not a valid otpauth URL.
    * - Fixme: ⚠️️ More info here: https://github.com/calleluks/Tofu/blob/master/Tofu/Account.swift
    * ## Examples
    * OTPAccount(url: URL("otpauth://totp/test?secret=GEZDGNBV"))
    * - Parameter url: URL object to init from
    */
   public init(url: URL) throws {
      let host = try OTPAccIniter.validateHost(url: url)
      let queryItems = try OTPAccIniter.getQueryItems(url: url)
      let labelComponents = OTPAccIniter.getLabelComponents(url: url)
      let name = try OTPAccIniter.getName(labelComponents: labelComponents)
      let issuer = OTPAccIniter.getIssuer(labelComponents: labelComponents)
      let query = try Self.query(queryItems: queryItems, host: host)
      self.init(
         name: name, // Set the name of the OTP account to the parsed name
         issuer: issuer ?? query.issuer, // Set the issuer of the OTP account to the parsed issuer or the query issuer if the parsed issuer is nil
         imageURL: query.imageURLString, // Set the image URL of the OTP account to the parsed image URL
         otp: query.otp, // Set the OTP of the OTP account to the parsed OTP
         generatorType: query.generatorType // Set the generator type of the OTP account to the parsed generator type
      ) // Initialize the OTP account with the parsed values
   }
}
