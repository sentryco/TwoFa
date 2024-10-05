import Foundation
/**
 * Parsing
 * - Description: This extension provides methods for parsing OTPAccount data from URL query items and host. It includes a QueryResult struct for storing the parsed data and a method for creating a QueryResult instance from the provided query items and host.
 */
extension OTPAccount {
   /**
    * Internal data object
    * - Description: This is an internal struct used to store the parsed data from the URL query items and host. It includes the issuer, OTP, generator type, and an optional image URL string.
    * - Fixme: ⚠️️ Move to own file?
    */
   internal struct QueryResult {
      /**
       * The issuer of the account for which the one-time password is being generated (optional)
       * - Description: This field specifies the organization or service that provides the OTP account. It is used to differentiate between multiple accounts, especially when the same user has OTPs for different services.
       */
      let issuer: String?
      /**
       * The secret key used to generate the one-time password
       * - Description: This is the secret key used to generate the one-time password. It is a crucial part of the OTP generation process, as it is used in conjunction with the chosen algorithm to create a unique OTP.
       */
      let otp: OTP
      /**
       * The type of one-time password generator to use
       * The generator type determines the method of generating the one-time password, either based on a time interval (TOTP) or a counter value (HOTP).
       */
      let generatorType: GeneratorType
      /**
       * The URL of an image associated with the account (optional)
       * - Description: This is a URL string that points to an image associated with the OTP account. This could be a logo or any other image that helps identify the account. This field is optional and may not be present for all accounts.
       */
      let imageURLString: String?
   }
   /**
    * Creates a `QueryResult` from different `URLQueryItem's` and host
    * - Description: This method creates a QueryResult instance from the provided URL query items and host. The QueryResult instance contains the parsed data necessary for OTP account setup, including the issuer, OTP, generator type, and an optional image URL string.
    * - Fixme: ⚠️️ maybe use the builder design pattern?
    * - Parameters:
    *   - queryItems: query items from URL
    *   - host: host: totp or htop
    */
   internal static func query(queryItems: [URLQueryItem], host: String) throws -> QueryResult {
      var secret: Data = .init() // The key that generates the OTP
      var algo: Algorithm = .sha1 // Cryptography algo used
      var digits: Int = 6 // Between 6 and 8
      var generatorType: GeneratorType = host == "totp" ? .totp : .htop(0) // Determine generator type based on host
      var period: Double = 30 // Time until the OTP resets
      var issuer: String? // From who was the OTP issued (not always included)
      var imageURLString: String? // The image URL string of the OTP account (optional)
      for queryItem: URLQueryItem in queryItems { // Iterates over each URLQueryItem in the queryItems array to process and extract OTP account information
         try QueryUtil.processQueryItem( // Process the query item
            queryItem: queryItem, // The query item to process
            secret: &secret, // The secret to process
            algo: &algo, // The algorithm to process
            digits: &digits, // The digits to process
            issuer: &issuer, // The issuer to process
            imageURLString: &imageURLString, // The image URL string to process
            generatorType: &generatorType, // The generator type to process
            period: &period // The period to process
         )
      }
      if secret.isEmpty { // Check if the secret data is empty, which is required for generating an OTP
         throw OTPError.invalidURL(reason: "Doesn't have secret")
      } // Throw an error if the secret is empty
      let otp: OTP = try .init( // Initialize an OTP instance using the parsed secret, period, digits, and algorithm
         secret: secret, // Set the secret to the parsed secret
         period: period, // Set the period to the parsed period
         digits: digits, // Set the digits to the parsed digits
         algo: algo // Set the algorithm to the parsed algorithm
      )
      return .init( // Returns a QueryResult instance initialized with the parsed issuer, OTP, generator type, and image URL string
         issuer: issuer, // Set the issuer of the OTP account to the parsed issuer
         otp: otp, // Set the OTP of the OTP account to the created OTP
         generatorType: generatorType, // Set the generator type of the OTP account to the parsed generator type
         imageURLString: imageURLString // Set the image URL string of the OTP account to the parsed image URL string
      )
   }
}
