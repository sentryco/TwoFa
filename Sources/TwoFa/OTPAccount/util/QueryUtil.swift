import Foundation
// fixme: ⚠️️ add unit tests for these?
// This utility class provides methods for processing URL query items related to OTP (One-Time Password) account setup.
class QueryUtil {
   /**
    * Process the query item
    * - Description: This method processes a given query item by determining its key and delegating the appropriate processing function to handle its value. It updates the passed-in references with the processed values necessary for OTP account setup.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - secret: The secret to process
    *   - algo: The algorithm to process
    *   - digits: The digits to process
    *   - issuer: The issuer to process
    *   - imageURLString: The image URL string to process
    *   - generatorType: The generator type to process
    *   - period: The period to process
    */
   static func processQueryItem(queryItem: URLQueryItem, secret: inout Data, algo: inout Algorithm, digits: inout Int, issuer: inout String?, imageURLString: inout String?, generatorType: inout GeneratorType, period: inout Double) throws {
      switch queryItem.name {
      case KeyType.secret.stringValue: // Check if the query name is "secret"
         processSecret(queryItem: queryItem, secret: &secret) // Decode the secret from the query item and store it in the 'secret' parameter
      case KeyType.algorithm.stringValue: // Check if the query name is "algorithm"
         processAlgorithm(queryItem: queryItem, algo: &algo) // Set the algorithm based on the value provided in the query item
      case KeyType.digits.stringValue: // Check if the query name is "digits"
         try processDigits(queryItem: queryItem, digits: &digits) // Process the digits from the query item. If the digits value is not within the range of 6 to 9, an error is thrown.
      case KeyType.issuer.stringValue: // Check if the query name is "issuer"
         issuer = queryItem.value // Assign the value of the query item to the issuer variable
      case KeyType.image.stringValue: // Check if the query name is "image"
         try processImage(queryItem: queryItem, imageURLString: &imageURLString) // Extract the image URL string from the query item and assign it to the 'imageURLString' variable
      case KeyType.counter.stringValue: // Check if the query name is "counter"
         processCounter(queryItem: queryItem, generatorType: &generatorType) // Decode the counter value from the query item and update the generatorType to HOTP with the new counter value
      case KeyType.period.stringValue: // Check if the query name is "period"
         try processPeriod(queryItem: queryItem, period: &period) // Decode the period value from the query item and update the 'period' variable with the new value
      default: break
      }
   }
}
// fix: make these fileprivate?
extension QueryUtil {
   /**
    * Process the secret
    * - Description: This method decodes the secret from the query item and converts it from a base64 encoded string to raw `Data`. The secret is a crucial part of the OTP generation process, as it is used in conjunction with the chosen algorithm to create a unique OTP. If the secret cannot be decoded or is missing, the method does not alter the passed `secret` parameter.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - secret: The secret to process
    */
   static func processSecret(queryItem: URLQueryItem, secret: inout Data) {
      guard let secretString: String = queryItem.value,
               let secretData: Data = .init(base64Encoded: secretString)
      else { return }
      secret = secretData // Set the secret to the converted data
   }
   /**
    * Process the algorithm
    * - Description: This method processes the algorithm from the query item. It checks the value of the query item and sets the algorithm accordingly. If the value is "SHA256", it sets the algorithm to SHA256. If the value is "SHA512", it sets the algorithm to SHA512. If the value is neither, it does not alter the passed `algo` parameter.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - algo: The algorithm to process
    */
   static func processAlgorithm(queryItem: URLQueryItem, algo: inout Algorithm) {
      switch queryItem.value {
      case .some(Algorithm.sha256.rawValue.uppercased()): algo = .sha256 // Set the algorithm to SHA256 if the query value is "SHA256"
      case .some(Algorithm.sha512.rawValue.uppercased()): algo = .sha512 // Set the algorithm to SHA512 if the query value is "SHA512"
      default: break
      }
   }

   /**
    * Process the digits
    * - Description: This method processes the digits from the query item. It checks the value of the query item and sets the digits accordingly. If the value is not within the range of 6 to 9, an error is thrown. If the value is within the range, it sets the digits to the converted integer value. If the value is neither, it does not alter the passed `digits` parameter.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - digits: The digits to process
    */
   static func processDigits(queryItem: URLQueryItem, digits: inout Int) throws {
      guard let string: String = queryItem.value, let digitsVal = Int(string) else { return }
      if digitsVal < 6 || digitsVal > 9 {
         throw OTPError.invalidURL(reason: "Digit out of bound: \(String(describing: queryItem.value))")
      }
      digits = digitsVal // Set the digits to the converted integer
   }

   /**
    * Process the image
    * - Description: This method processes the image from the query item. It checks the value of the query item and sets the image URL string accordingly. If the value is not a valid URL, an error is thrown. If the value is a valid URL, it sets the image URL string to the absolute string of the image URL.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - imageURLString: The image URL string to process
    */
   static func processImage(queryItem: URLQueryItem, imageURLString: inout String?) throws {
      guard let string: String = queryItem.value,
               let imgURL: URL = .init(string: string) else {
         throw OTPError.invalidURL(reason: "Image url invalid: \(String(describing: queryItem.value))")
      }
      imageURLString = imgURL.absoluteString // Set the image URL string to the absolute string of the image URL
   }
   /**
    * Process the counter
    * - Description: This method processes the counter from the query item. It checks the value of the query item and sets the generator type to HOTP with the counter value accordingly. If the value is not a valid integer, the method returns without altering the generator type. If the value is a valid integer, it sets the generator type to HOTP with the provided counter value.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - generatorType: The generator type to process
    */
   static func processCounter(queryItem: URLQueryItem, generatorType: inout GeneratorType) {
      guard let string: String = queryItem.value, let counterVal: Int = .init(string) else { return }
      generatorType = .htop(counterVal) // Set the generator type to HOTP with the counter value
   }
   /**
    * Process the period
    * - Description: This method processes the period from the query item. It checks the value of the query item and sets the period accordingly. The period represents the length of time for which a Time-based One-Time Password (TOTP) is valid. If the value is not a valid double or is less than 1, an error is thrown. If the value is valid, it sets the period to the converted double value.
    * - Parameters:
    *   - queryItem: The query item to process
    *   - period: The period to process
    */
   static func processPeriod(queryItem: URLQueryItem, period: inout Double) throws {
      guard let string: String = queryItem.value, let periodVal: Double = .init(string) else { return }
      if periodVal < 1 { throw OTPError.invalidURL(reason: "Period less than 1: \(periodVal)") }
      period = periodVal // Set the period to the converted double
   }
}
