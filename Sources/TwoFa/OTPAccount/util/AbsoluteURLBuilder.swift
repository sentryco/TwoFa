import Foundation
/**
 * This class is used to build the absolute URL
 * - Description: This class is responsible for constructing the absolute URL used for OTP (One-Time Password) generation.
 *                It creates URL components and query items based on the OTP configuration and generator type (TOTP or HOTP).
 *                The resulting URL is compliant with the otpauth URL scheme used for OTP transfer.
 */
internal class AbsoluteURLBuilder {
   /**
    * Create a URL components object
    * - Description: This method creates a URLComponents object with the otpauth scheme
    *                and sets the host to the generator type string value ("totp" or "htop").
    *                The path of the URL is set to "/".
    *                This URLComponents object is used as the base for constructing the absolute URL for OTP generation.
    */
   static func createURLComponents(generatorType: GeneratorType) -> URLComponents {
      // Create and configure a URLComponents object for OTP
      var components = URLComponents()
      components.scheme = "otpauth" // Set the scheme to "otpauth"
      components.host = generatorType.stringValue // Set the host to the generator type ("totp" or "hotp")
      components.path = "/"
      return components
   }
   /**
    * Create an array of URL query items
    * - Description: This method constructs an array of URLQueryItem objects,
    *                each representing a query parameter for the OTP URL.
    *                The query parameters include the secret key encoded in base64,
    *                the hashing algorithm, and the number of digits in the OTP.
    *                These parameters are essential for the OTP generation process
    *                and are used to configure the OTP generator according to the
    *                specified settings.
    */
   static func createQueryItems(otp: OTP) -> [URLQueryItem] {
      let parameters = [
         (KeyType.secret.stringValue, otp.secret.base64EncodedString()), // Secret as base64-encoded string
         (KeyType.algorithm.stringValue, otp.algo.rawValue.uppercased()), // Algorithm in uppercase
         (KeyType.digits.stringValue, String(otp.digits)) // Digits as string
      ]
      
      // Create an array of URL query items
      return parameters.map { (name, value) in
         URLQueryItem(
            name: name, // The name of the query item
            value: value // The value of the query item
         )
      }
   }
   /**
    * Add generator type specific items to the query items
    * - Description: This function adds generator type specific items to the query items.
    *                Depending on the generator type (HOTP or TOTP), it appends the counter
    *                or period to the query items respectively. This is crucial for the OTP
    *                generation process as it determines the moving factor in the OTP algorithm.
    */
   static func addGeneratorTypeToQueryItems(queryItems: [URLQueryItem], otp: OTP, generatorType: GeneratorType) -> [URLQueryItem] {
      // Create a new query item based on the generator type
      let additionalQueryItem: URLQueryItem
      switch generatorType { // Switch on the generator type
      case .htop(let counter): // If the generator type is HOTP
         // Create the counter query item
         additionalQueryItem = URLQueryItem(
            name: KeyType.counter.stringValue, // The name of the query item
            value: String(counter) // The value of the query item
         )
      case .totp: // If the generator type is TOTP
         // Create the period query item
         additionalQueryItem = URLQueryItem(
            name: KeyType.period.stringValue, // The name of the query item
            value: String(otp.period) // The value of the query item
         )
      }
      // Return the updated query items array
      return queryItems + [additionalQueryItem]
   }
   /**
    * Add issuer and name to the path
    * - Description: This function adds the issuer and name to the URL path.
    *                If the issuer exists, it appends both the issuer and name to
    *                the URL path and adds the issuer to the query items. If the
    *                issuer does not exist, it only appends the name to the URL path.
    */
   static func addIssuerAndNameToPath(components: URLComponents, issuer: String?, name: String?, queryItems: inout [URLQueryItem]) -> String {
      var path = components.path
      let nameComponent = name ?? "" // Ensure name is not nil
      if let issuer = issuer { // If the issuer exists
         path += "\(issuer):\(nameComponent)" // Add the issuer and name to the path of the URL
         // Add the issuer to the query items as a string
         queryItems.append(URLQueryItem(
            name: KeyType.issuer.stringValue, // The name of the query item
            value: issuer // The value of the query item
         ))
      } else {
         path += nameComponent // Add the name to the path of the URL
      }
      return path
   }
   /**
    * Add image URL to query items
    * - Description: This function adds the image URL to the query items if it exists.
    *                The image URL is used to provide a visual identifier for the OTP
    *                account, which can be displayed in the user interface.
    */
   static func addImageURLToQueryItems(queryItems: [URLQueryItem], imageURL: String?) -> [URLQueryItem] {
      // Add the image URL to the query items if it exists
      guard let imageURL = imageURL else { return queryItems }
      // Add the image URL to the query items as a string
      return queryItems + [URLQueryItem(
         name: KeyType.image.stringValue, // The name of the query item
         value: imageURL // The value of the query item
      )]
   }
}
