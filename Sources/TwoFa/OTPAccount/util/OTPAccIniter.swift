import Foundation
/**
 * This class is used to parse the URL and create the OTPAccount
 * - Description: This class is responsible for initializing an OTPAccount
 *                instance by parsing the provided URL and extracting the
 *                necessary information such as host, query items, label
 *                components, and name. It validates the host, retrieves the
 *                query items and label components, and extracts the name from
 *                the label components. It throws an error if any of these
 *                components are invalid or missing.
 * - fixme: ⚠️️ move to own file? 👈
 */
internal class OTPAccIniter {
   /**
    * Validate the host of the URL
    * - Description: This method validates the host of the URL. It checks if
    *                the host is either "hotp" or "totp", which are the two
    *                types of OTP generation algorithms. If the host is neither
    *                of these, it throws an error indicating that the host is
    *                incorrect.
    * - Parameter url: The URL to validate
    * - Throws: An error if the host is invalid
    * - Returns: The host if it is valid
    */
   static func validateHost(url: URL) throws -> String {
      // Check if the host of the URL is either "hotp" or "totp", which are the two types of OTP generation algorithms.
      guard let host: String = url.host, host == "hotp" || host == "totp" else {
         throw OTPError.invalidURL(reason: "incorrect host: \(String(describing: url.host))")
      }
      return host
   }

   /**
    * Get the query items from the URL
    * - Description: This method retrieves the query items from the provided
    *                URL. Query items are the parameters in the URL that follow
    *                the '?' and are separated by '&'. They are used to pass
    *                additional information to the server. If the URL does not
    *                contain any query items, the method throws an error.
    * - Parameter url: The URL to get the query items from
    * - Throws: An error if the URL does not contain any query items
    * - Returns: The query items from the URL
    */
   static func getQueryItems(url: URL) throws -> [URLQueryItem] {
      // Retrieve the query items from the URLComponents.
      guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
            !queryItems.isEmpty else {
         throw OTPError.invalidURL(reason: "No query items found in URL")
      }
      return queryItems
   }

   /**
    * Get the label components from the URL
    * - Description: This method retrieves the label components from the
    *                provided URL. Label components are the parts of the URL
    *                that follow the host and are separated by colons. They
    *                typically include the issuer and account name. This
    *                method extracts the path from the URL, removes leading
    *                and trailing slashes, and splits it into components
    *                separated by colons.
    * - Parameter url: The URL to get the label components from
    * - Returns: The label components from the URL
    */
   static func getLabelComponents(url: URL) -> [String] {
      // Extract the path from the URL
      let path = url.path
      // Remove leading and trailing slashes
      let trimmedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
      // Split the path into components separated by colons
      let components = trimmedPath.components(separatedBy: ":")
      // This is used to parse the label components of the OTP URL, which may include the issuer and account name.
      return components
   }

   /**
    * Get the name from the label components
    * - Description: This method extracts the name from the label components
    *                of the URL. The label components may include the issuer
    *                and account name, separated by colons. This method
    *                specifically retrieves the last component, which
    *                typically represents the account name, and trims any
    *                whitespace.
    * - Parameter labelComponents: The label components to get the name from
    * - Throws: An error if the label components do not contain a name
    * - Returns: The name from the label components
    */
   static func getName(labelComponents: [String]) throws -> String? {
      // Check if the labelComponents array is not empty. If it is empty, throw an error.
      guard !labelComponents.isEmpty else {
         throw OTPError.invalidURL(reason: "incorrect URL components")
      }
      return labelComponents.last?.trimmingCharacters(in: CharacterSet.whitespaces)
   }

   /**
    * Get the issuer from the label components
    * - Description: This method extracts the issuer from the label
    *                components of the URL. The label components may include
    *                the issuer and account name, separated by colons. This
    *                method specifically retrieves the first component if
    *                there are more than one, which typically represents the
    *                issuer of the account.
    * - Parameter labelComponents: The label components to get the issuer from
    * - Returns: The issuer from the label components, or nil if it does not exist
    */
   static func getIssuer(labelComponents: [String]) -> String? {
      // If there are multiple label components, return the first one as the issuer, otherwise return nil.
      labelComponents.count > 1 ? labelComponents.first : nil
   }
}
