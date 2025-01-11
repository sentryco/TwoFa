import XCTest
@testable import TwoFa

class DataExtTests: XCTestCase {
        // Start of Selection

        /// Tests the initialization of `Data` from a hexadecimal string.
        func testInitWithHex() {
            // Test with a valid hexadecimal string
            let hexString = "48656c6c6f" // "Hello" in hex
            let expectedData = "Hello".data(using: .utf8)!
            let dataFromHex = Data(hex: hexString)
            XCTAssertEqual(dataFromHex, expectedData, "Data initialized from hex string should match expected data.")

            // Test with "0x" prefix
            let hexStringWithPrefix = "0x48656c6c6f"
            let dataFromHexWithPrefix = Data(hex: hexStringWithPrefix)
            XCTAssertEqual(dataFromHexWithPrefix, expectedData, "Data initialized from hex string with '0x' prefix should match expected data.")
        }

        /// Tests the initialization of `[UInt8]` from a valid hexadecimal string.
        func testValidHexString() {
            let hexString = "48656c6c6f" // "Hello" in hex
            let byteArray = [UInt8](hex: hexString)
            XCTAssertEqual(byteArray, [72, 101, 108, 108, 111])
        }
        
        /// Tests the handling of an odd-length hexadecimal string when initializing `[UInt8]`.
        func testOddLengthHexString() {
            let hexString = "123" // Should be interpreted as "0123"
            let byteArray = [UInt8](hex: hexString)
            XCTAssertEqual(byteArray, [1, 35])
        }
        
        /// Tests the initialization of `[UInt8]` from a hexadecimal string with "0x" prefix.
        func testHexStringWithPrefix() {
            let hexString = "0x123456"
            let byteArray = [UInt8](hex: hexString)
            XCTAssertEqual(byteArray, [18, 52, 86])
        }
        
        /// Tests the handling of an invalid hexadecimal string when initializing `[UInt8]`.
        func testInvalidHexString() {
            let hexString = "GGGGGG" // "G" is not a valid hex character
            let byteArray = [UInt8](hex: hexString)
            XCTAssertTrue(byteArray.isEmpty)
        }
        
        /// Tests the handling of an empty hexadecimal string when initializing `[UInt8]`.
        func testEmptyHexString() {
            let hexString = ""
            let byteArray = [UInt8](hex: hexString)
            XCTAssertTrue(byteArray.isEmpty)
        }

}
// tests for encoding type
 extension DataExtTests {

    /// Tests that the `encodingType` property correctly identifies ASCII data.
    func testEncodingTypeASCII() {
        // Given ASCII string data
        let asciiString = "Hello, World!"
        guard let data = asciiString.data(using: .ascii) else {
            XCTFail("Failed to create ASCII data")
            return
        }
        
        // When checking the encoding type
        let encodingType = data.encodingType
        
        // Then it should be .ascii
        XCTAssertEqual(encodingType, Data.EncodingType.ascii, "Encoding type should be ASCII")
    }
    
    /// Tests that the `encodingType` property correctly identifies Base64 encoded data.
    func testEncodingTypeBase64() {
        // Given Base64 string data
        let base64String = "SGVsbG8sIFdvcmxkIQ==" // "Hello, World!" in Base64
        // Create data from the Base64 string itself
        guard let data = base64String.data(using: .utf8) else {
            XCTFail("Failed to create data from Base64 string")
            return
        }
        
        // When checking the encoding type
        let encodingType = data.encodingType
        
        // Then it should be .base64
        XCTAssertEqual(encodingType, Data.EncodingType.base64, "Encoding type should be Base64")
    }
    
    /// Tests that the `encodingType` property correctly identifies hexadecimal encoded data.
    func testEncodingTypeHex() {
        // Given data that cannot be represented as a UTF8 string
        let hexString = "FFFEFDFCFAF8F6F4F2F0" // Random hex data that is invalid UTF8
        let data = Data(hex: hexString)
        
        // When checking the encoding type
        let encodingType = data.encodingType
        
        // Then it should be .hex
        XCTAssertEqual(encodingType, .hex, "Encoding type should be Hex")
    }
 }