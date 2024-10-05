import Foundation
/**
 * Getter
 * - Description: This extension provides computed properties that facilitate access to the current one-time password and the absolute URL representation of the OTPAccount. These properties abstract the underlying logic required to generate the current password based on the generator type and to construct a URL that encapsulates all the account details for sharing or exporting purposes.
 */
extension OTPAccount {
   /**
    * A computed property representing the current password at any given time
    * - Description: This property generates and returns the current one-time password (OTP) based on the generator type. If the generator type is HOTP, it generates an OTP for the specified counter value. If the generator type is TOTP, it generates an OTP for the current time.
    */
   public var currentCode: String? {
      if case .htop(let counter/*: Int*/) = self.generatorType { // Check if the generator type is HOTP
         // Generate an OTP for the specified counter value using the `generate` method and return it
         return try? otp.generate(counter: UInt64(counter))
      } else { // If the generator type is TOTP
         // Generate an OTP for the current time using the `generate` method and return it
         return try? otp.generate(date: Date())
      }
   }
   /**
    * Returns `absolute-URL` from `OTPAccount`
    * - Abstract: Create `otp-URL` for export etc
    * - Description: This computed property generates an absolute URL from the OTPAccount instance. The URL is constructed using various properties of the OTPAccount such as the generator type, OTP, issuer, name, and image URL. This URL can be used for exporting the OTPAccount or sharing it across different platforms.
    * - Fixme: ⚠️️ break up this var a bit, consult copilot etc
    * ## Examples
    * OTPAccount().absoluteURL // URL(string: "otpauth://hotp/test?secret=GEZDGNBV&algorithm=SHA512&digits=6&counter=1"
    */
   public var absoluteURL: URL {
      var components: URLComponents = AbsoluteURLBuilder.createURLComponents(generatorType: generatorType) // Create a URL components object
      var queryItems: [URLQueryItem] = AbsoluteURLBuilder.createQueryItems(otp: otp) // Create an array of URL query items
      queryItems = AbsoluteURLBuilder.addGeneratorTypeToQueryItems(queryItems: queryItems, otp: otp, generatorType: generatorType) // Add generator type specific items
      components.path = AbsoluteURLBuilder.addIssuerAndNameToPath(components: components, issuer: issuer, name: name, queryItems: &queryItems) // Add issuer and name to the path
      queryItems = AbsoluteURLBuilder.addImageURLToQueryItems(queryItems: queryItems, imageURL: imageURL) // Add image URL to query items
      components.queryItems = queryItems // Set the query items of the URL components object to the query items array
      return components.url! // Return the URL from the URL components object
   }
}
