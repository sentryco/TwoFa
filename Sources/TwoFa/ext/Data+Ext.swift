import Foundation
/**
 * Used when creating data of hex value I.E: "3132333435363738393031323334353637383930"
 * - Description: This extension provides a convenient way to initialize a Data object from a hexadecimal string. It is particularly useful when dealing with data that is represented as hexadecimal strings, such as cryptographic keys or binary data serialized as text.
 */
extension Data {
   /**
    * - Parameter hex: hex string to convert to data
    * - Description: This initializer takes a hexadecimal string as input and converts it into a Data object. The hexadecimal string is first converted into an array of UInt8 values, which is then used to initialize the Data object. This is particularly useful when dealing with data that is represented as hexadecimal strings, such as cryptographic keys or binary data serialized as text.
    */
   public init(hex: String) {
      self.init([UInt8](hex: hex)) // Convert the hexadecimal string to an array of UInt8 values and initialize the Data object with the array
   }
}
/**
 * Array ext (String -> UInt8 Array)
 * - Description: This extension provides methods for converting hexadecimal strings to arrays of UInt8, which represent bytes. This is useful for encoding and decoding data that is represented in hexadecimal string format.
 */
extension Array where Element == UInt8 {
   /**
    * Helper method to initialize an array with a reserved capacity
    * - Description: This method is a helper that initializes an array with a reserved capacity. It is used to optimize memory usage when the maximum capacity of the array is known beforehand, reducing the need for dynamic memory allocation during runtime.
    * - Remark: This method is used in the `Data+Ext` extension to initialize an array with a reserved capacity. The method initializes the array with an empty array and reserves capacity for the array to avoid reallocations during append operations.
    * - Parameters:
    *    - reserveCapacity: The number of elements to reserve capacity for
    */
   fileprivate init(reserveCapacity: Int) {
      self = [Element]() // Initialize the array with an empty array
      // Reserve capacity for the array to avoid reallocations during append operations
      self.reserveCapacity(reserveCapacity)
   }
   /**
    * Initializer for the Data class that takes in a hexadecimal string and converts it to a Data object. 
    * - Abstract: The purpose of this method is to provide a convenient way to convert a hexadecimal string to a Data object.
    * - Description: This initializer takes a hexadecimal string as input and converts it into an array of UInt8. The hexadecimal string is first parsed and each byte is converted into its corresponding UInt8 value. The array is then used to store these values. This is particularly useful when dealing with data that is represented as hexadecimal strings, such as cryptographic keys or binary data serialized as text.
    * - Remark: The method initializes the Data object with the estimated capacity of the hexadecimal string, then loops through each character in the hexadecimal string, parsing each byte and appending it to the Data object. If the hexadecimal string is invalid, the method removes all bytes from the Data object. 
    * - Parameter hex: Hex string to convert to data
    */
   public init(hex: String) {
      self.init()
      // Adjusting capacity for the byte array, considering two characters form one byte.
      reserveCapacity(hex.unicodeScalars.lazy.underestimatedCount / 2)
      // Removing "0x" prefix if present, to correctly process the hex string.
      let hexStr = hex.dropFirst(hex.hasPrefix("0x") ? 2 : 0)
      var tempByte: UInt8? // Temporary storage for the current byte being constructed.
      for char in hexStr {
         // Convert the current hex character to its byte value.
         if let byte = char.hexDigitValue {
            let value = UInt8(byte)
            // If there's a byte in temporary storage, combine it with the current value and append to the Data object.
            if let tb = tempByte {
               append(tb << 4 | value)
               tempByte = nil // Clear temporary storage after appending.
            } else {
               tempByte = value // Store current value in temporary storage for next iteration.
            }
         } else {
            // If an invalid character is encountered, clear the Data object and exit.
            removeAll()
            return
         }
      }
      // Append any remaining byte in temporary storage to the Data object.
      if let remainingByte = tempByte {
         append(remainingByte)
      }
   }
}
/**
 * Type
 */
extension Data {
   /**
    * Encoding type
    * - Description: The `EncodingType` enum specifies the encoding formats that can be used to represent binary data as text. Each case of the enum represents a different encoding format. ASCII is a character-encoding standard for electronic communication, HEX is a base 16 number system commonly used in computing to represent binary data, and Base64 is an encoding scheme that represents binary data in an ASCII string format by translating it into a radix-64 representation.
    * - Fixme: ⚠️️ add support for base32, if its possible? ask copilot? check other libs, the oak lib etc?
    */
   public enum EncodingType {
      /// ASCII encoding format for text representation of binary data.
      case ascii
      /// Hexadecimal encoding format for text representation of binary data.
      case hex
      /// Base64 encoding format for text representation of binary data.
      case base64
   }
   /**
    * Encoding type
    * - Description: This computed property determines the encoding type of the data object. It checks if the data can be represented as a Base64 encoded string, ASCII string, or as a hexadecimal string, and returns the corresponding `EncodingType`. This is useful for understanding the format of the data and for performing appropriate encoding or decoding operations.
    * - Fixme: ⚠️️ add this to unit tests
    */
   public var encodingType: EncodingType {
      // Check if the data can be represented as a Base64 encoded string
      if !self.base64EncodedString().isEmpty {
         // If the data can be represented as a Base64 encoded string, return .base64
         return .base64
      }
      // Check if the data can be represented as an ASCII string
      else if let str: String = .init(data: self, encoding: .ascii), !str.isEmpty {
         // If the data can be represented as an ASCII string, return .ascii
         return .ascii
      }
      // If the data cannot be represented as a Base64 or ASCII string, it must be a hexadecimal string
      else {
         return .hex
      }
   }
}
