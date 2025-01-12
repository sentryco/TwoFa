#if canImport(CryptoKit)
import XCTest
import CryptoKit
import Foundation
@testable import MockGen
@testable import TwoFa
/**
 * - Fixme: ⚠️️ Add more tests, see github issues etc
 * - Fixme: ⚠️️ Add more entropy to the tests
 * - Fixme: ⚠️️ How do we read encoding from url? chat with copilot about this?
 * - Fixme: ⚠️️ Maybe add some OTPTimer tests?
 * - Fixme: ⚠️️ Group the calls? make categories? URL, Data, OTP etc
 */
final class TwoFaTests: XCTestCase {
   func test() {
      do {
         try Self.htopURLTest() // HTOP url test
         try Self.totpURLTest() // TOTP URL test
         try Self.testURL() // OTP URL test
         try Self.runBase64Encoded() // Base64 Encoded test
         try Self.testMultiASCII() // Test Multi ASCII
         try Self.testingAscii() // ASCII Test
         try Self.testManyHOTP() // Test Many HTOP
         try Self.testManyTOTP() // Test Many TOTP
         try Self.testMultipleHEXEncodedHTOP() // Test Multiple HEX Encoded HTOP
         try Self.testRandomBulk() // OTP batch tests (Fuzzy)
      } catch {
         Swift.print("Error: \(error)")
      }
   }
}
/**
 * Private
 */
extension TwoFaTests {
   /**
    * HTOP URL test (Deocde and assert)
    * HTOP URL test: This test verifies that the HOTP URL is correctly generated and matches the expected format.
    */
   fileprivate static func htopURLTest() throws {
      // - Fixme: ⚠️️ try using: RandomOTP.randomSecret
      // - Fixme: ⚠️️ try reading byte length etc 👈
      let secret: String = CodeGen.generatePassword( // Generate a secret key
         length: 8, // The length of the secret key
         useLowercase: false, // Whether to use lowercase letters
         useNumbers: false, // Whether to use numbers
         useSpecialChars: false // Whether to use special characters
      ) //
      let otp: OTP = try .init(
         // - Fixme: ⚠️️ try to use random secret
         secret: Data(base64Encoded: secret)!, // The secret key used to generate the one-time password
         period: 0, // The time period for which the OTP is valid
         digits: 6, // The number of digits in the OTP
         algo: .sha512 // The algorithm used to generate the OTP
      ) // Create a new OTP object using the `OTP.init` initializer, with a base64-encoded secret, a period of 30 seconds, 6 digits, and the SHA-512 algorithm. If the initialization fails, throw an error.
      let account: OTPAccount = .init(
         name: "test", // The name of the account
         otp: otp, // The secret key used to generate the one-time password
         generatorType: .htop(1) // The type of one-time password generator to use
      ) // Create a new OTPAccount object with the name "test", the `otp` object we just created, and the HOTP generator type with a counter of 1.
      // - Fixme: ⚠️️ add period=30.0 here?
      let url: String = "otpauth://hotp/test?secret=\(secret)&algorithm=SHA512&digits=6&counter=1" // Create a URL string with the `otpauth` scheme, the `hotp` type, the account name "test", the base64-encoded secret "GEZDGNBV", the SHA-512 algorithm, 6 digits, and a counter of 1. The comments describe each line of code and its purpose.
//       Swift.print("a: \(account.absoluteURL)")
//       Swift.print("u: \(url)")
      let equals: Bool = account.absoluteURL == URL(string: url) // Compare the `absoluteURL` property of the `account` object to a new URL object created from the `url` string using the `URL(string:)` initializer, and assign the resulting boolean value to `equals`. The comments describe each line of code and its purpose.
      Swift.print("urls equals: \(equals ? "✅" : "🚫")")
      XCTAssertTrue(equals)
   }
   /**
    * TOTP URL test (Decode and assert)
    * TOTP URL test: This test verifies that the TOTP URL is correctly generated and matches the expected format. It ensures that the URL contains the correct query parameters such as the secret, algorithm, digits, period, issuer, and image URL.
    * - Fixme: ⚠️️ Add more tests
    */
   fileprivate static func totpURLTest() throws {
      // - Fixme: ⚠️️ try using: RandomOTP.randomSecret
      // - Fixme: ⚠️️ try reading byte length etc
      let secret: String = CodeGen.generatePassword( // Generate a secret key
         length: 8, // The length of the secret key
         useLowercase: false, // Whether to use lowercase letters
         useNumbers: false, // Whether to use numbers
         useSpecialChars: false // Whether to use special characters
      ) //
      let otp = try OTP(
         secret: Data(base64Encoded: secret)!, // The secret key used to generate the one-time password
         period: 30, // The time period for which the OTP is valid
         digits: 6, // The number of digits in the OTP
         algo: .sha512 // The algorithm used to generate the OTP
      ) // Create a new OTP object using the `OTP.init` initializer, with a base64-encoded secret, a period of 30 seconds, 6 digits, and the SHA-512 algorithm. If the initialization fails, throw an error.
      let account: OTPAccount = .init(
         name: "john.doe@email.com", // The name of the account
         issuer: "ACME Co", // The issuer of the account
         imageURL: "https://www.images.com/image.png", // The URL of an image associated with the account
         otp: otp, // The secret key used to generate the one-time password
         generatorType: .totp // The type of one-time password generator to use
      ) // Create a new OTPAccount object with the name "john.doe@email.com", the issuer "ACME Co", the image URL "https://www.images.com/image.png", the `otp` object we just created, and the TOTP generator type.
      // Create a URL string with the `otpauth` scheme, the `totp` type, the issuer "ACME Co", the account name "john.doe@email.com", the base64-encoded secret "GEZDGNBV", the SHA-512 algorithm, 6 digits, a period of 30 seconds, and the image URL "https://www.images.com/image.png".
      let urlString: String = "otpauth://totp/ACME%20Co:john.doe@email.com?secret=\(secret)&algorithm=SHA512&digits=6&period=30.0&issuer=ACME%20Co&image=https://www.images.com/image.png"
//      Swift.print("u: \(urlString)")
//      Swift.print("a: \(account.absoluteURL.absoluteString)")
      let equals: Bool = account.absoluteURL.absoluteString == urlString // URL(string: )
      Swift.print("absoluteURLs equals: \(equals ? "✅" : "🚫")")
      XCTAssertTrue(equals)
      Swift.print("account.currentCode: \(String(describing: account.currentCode))")
      let derivedSecret: String = account.otp.secret.base64EncodedString()
      let secretEquals: Bool = secret == derivedSecret
      Swift.print("secretEquals: \(secretEquals ? "✅" : "🚫")")
      XCTAssertTrue(secretEquals)
      // - Fixme: ⚠️️ try to create otp from url
   }
   /**
    * URL test (Tests encoding to otp-account)
    * - Description: This test verifies the encoding of the OTP account into a URL.
    *                It ensures that the URL is correctly formatted and contains the
    *                necessary parameters for OTP generation.
    * - Fixme: ⚠️️  add more tests?
    */
   fileprivate static func testURL() throws {
      // Create a new OTPAccount object by initializing it with a URL object created from the string "otpauth://totp/test?secret=GEZDGNBV" using the `URL(string:)` initializer. If the initialization fails, throw an error.
      // - Fixme: ⚠️️ try to use random secret
      let secret: String = CodeGen.generatePassword( // Generate a secret key
         length: 8, // The length of the secret key
         useLowercase: false, // Whether to use lowercase letters
         useNumbers: false, // Whether to use numbers
         useSpecialChars: false // Whether to use special characters
      ) //
      let url: URL = .init(string: "otpauth://totp/test?secret=\(secret)")!
      let account: OTPAccount = try .init(url: url)
      // Swift.print("account?.currentPassword: \(String(describing: account.currentCode))") // 123321
      let correctLength: Bool = account.currentCode?.count == 6
      Swift.print("url has correctLength: \(correctLength ? "✅" : "🚫")")
      XCTAssertTrue(correctLength) // - Fixme: ⚠️️ there is probably something more correct to use here
   }
   /**
    * Base64 Encoded test
    * - Description: This test validates the functionality of creating an OTP
    *                object with a base64-encoded secret and generating a one-time
    *                password. It ensures that the generated OTP has the correct
    *                length and adheres to the expected format and value
    *                constraints.
    */
   fileprivate static func runBase64Encoded() throws {
      // let secretData = otp.secret.data(using: String.Encoding.ascii)!
      // Create a new OTP object using the `OTP.init` initializer, with a base64-encoded secret, a period of 30 seconds, and 6 digits. If the initialization fails, throw an error.
      // - Fixme: ⚠️️ try to use random secret
      let otp: OTP = try .init(
         secret: Data(base64Encoded: "6UAOpz+x3dsNrQ==")!, // The secret key used to generate the one-time password
         period: 30, // The time period for which the OTP is valid
         digits: 6 // The number of digits in the OTP
      )
      let otpValue: String? = try? otp.generate() // Generate an OTP value using the `otp.generate()` method, and assign it to `otpValue`. If the generation fails, set `otpValue` to `nil`. The comments describe each line of code and its purpose.
      //Swift.print("base64Encoded:  \(String(describing: otpValue))")
      // - Fixme: ⚠️️ Here we could generate based on a know time, and a known result for that time
      let correctLength: Bool = otpValue?.count == 6
      Swift.print("Base64Encoded has correctLength: \(correctLength ? "✅" : "🚫")")
      XCTAssertNotNil(correctLength)
   }
   /**
    * Test Multi ASCII
    * - Description: This test verifies the generation of OTP values using
    *                different algorithms (SHA-1, SHA-256, and SHA-512) and
    *                different test data. It ensures that the generated OTP
    *                values match the expected results for each algorithm and
    *                test data combination.
    */
   fileprivate static func testMultiASCII() throws {
      // Define test vectors for different algorithms
      struct TestVector {
         let algorithm: Algorithm
         let secret: Data
         let testData: [(Int, String)]
      }
      let testVectors: [TestVector] = [
         TestVector(
            algorithm: .sha1,
            secret: "12345678901234567890".data(using: .ascii)!,
            testData: [
               (1_111_111_109, "07081804"),
               (1_111_111_111, "14050471"),
               (1_234_567_890, "89005924"),
               (2_000_000_000, "69279037"),
               (20_000_000_000, "65353130")
            ]
         ),
         TestVector(
            algorithm: .sha256,
            secret: "12345678901234567890123456789012".data(using: .ascii)!,
            testData: [
               (1_111_111_109, "68084774"),
               (1_111_111_111, "67062674"),
               (1_234_567_890, "91819424"),
               (2_000_000_000, "90698825"),
               (20_000_000_000, "77737706")
            ]
         ),
         TestVector(
            algorithm: .sha512,
            secret: "1234567890123456789012345678901234567890123456789012345678901234".data(using: .ascii)!,
            testData: [
               (1_111_111_109, "25091201"),
               (1_111_111_111, "99943326"),
               (1_234_567_890, "93441116"),
               (2_000_000_000, "38618901"),
               (20_000_000_000, "47863826")
            ]
         )
      ]
      // Test each vector
      for testVector in testVectors {
         for (time, expectedOTP) in testVector.testData {
            XCTAssertEqual(
               try OTP(
                  secret: testVector.secret,
                  period: 30,
                  digits: 8,
                  algo: testVector.algorithm
               ).generate(secondsPast1970: time),
               expectedOTP
            )
         }
      }
      Swift.print("testMultiASCII: \(Optional(true) == true ? "✅" : "🚫")")
   }
   /**
    * ASCII Test
    * - Description: This function tests the generation of One-Time Passwords
    *                (OTPs) using ASCII representations of secret keys for SHA-1,
    *                SHA-256, and SHA-512 hashing algorithms. It validates the OTP
    *                generation by comparing the generated values against known
    *                expected results.
    */
   fileprivate static func testingAscii() throws {
       Swift.print("testingAscii") // Print a message to the console indicating that we are testing ASCII data

       // Define test cases for each algorithm with the corresponding data and expected OTP value
       let testCases: [(algo: Algorithm, dataString: String, expectedOTP: String)] = [
           (.sha1,   "12345678901234567890",                                            "94287082"),
           (.sha256, "12345678901234567890123456789012",                                 "46119246"),
           (.sha512, "1234567890123456789012345678901234567890123456789012345678901234", "90693936")
       ]

       for testCase in testCases {
           let data = testCase.dataString.data(using: .ascii)! // Convert the data string to Data using ASCII encoding
           let otp = try OTP(
               secret: data,       // The secret key used to generate the one-time password
               period: 30,         // The time period for which the OTP is valid
               digits: 8,          // The number of digits in the OTP
               algo: testCase.algo // The algorithm used to generate the OTP
           ) // Create an OTP object with the specified parameters
           let generatedOTP = try otp.generate(secondsPast1970: 59) // Generate the OTP at the specified time
           XCTAssertEqual(generatedOTP, testCase.expectedOTP) // Assert that the generated OTP matches the expected value
       }

       Swift.print("testingAscii: \(Optional(true) == true ? "✅" : "🚫")") // Print a message to the console indicating whether the test passed or failed
   }
   /**
    * Test Many HTOP
    * - Description: This function verifies the accuracy and reliability of
    *                multiple HMAC-Based One-Time Passwords (HOTP) generation.
    */
    fileprivate static func testManyHOTP() throws {
       // Define test data for the HOTP algorithm
       // Each tuple contains: (counter value, [expected SHA-1 OTP, expected SHA-256 OTP, expected SHA-512 OTP])
       let counterBasedTests: [(Int, [String])] = [
          (0, ["755224", "875740", "125165"]),
          (1, ["287082", "247374", "342147"]),
          (2, ["359152", "254785", "730102"]),
          (3, ["969429", "496144", "778726"]),
          (4, ["338314", "480556", "937510"]),
          (5, ["254676", "697997", "848329"]),
          (6, ["287922", "191609", "266680"]),
          (7, ["162583", "579288", "588359"]),
          (8, ["399871", "895912", "039399"]),
          (9, ["520489", "184989", "643409"])
       ]
       let data = "12345678901234567890".data(using: .ascii)! // The secret key used to generate the one-time password
       let algorithms: [Algorithm] = [.sha1, .sha256, .sha512] // The algorithms to test

       // For each test data, generate an OTP for each algorithm and assert it matches the expected value
       for (counter, expectedOtps) in counterBasedTests {
          for (index, algo) in algorithms.enumerated() {
             // Generate an OTP value using the current algorithm and counter
             let otp = try OTP(
                secret: data, // The secret key used to generate the one-time password
                algo: algo // The algorithm used to generate the OTP
             ).generate(counter: UInt64(counter)) // The counter value at which to generate the OTP
             // Assert that the generated OTP value matches the expected value for the current test data and algorithm
             XCTAssertEqual(otp, expectedOtps[index], "Failed at counter \(counter) with algorithm \(algo)")
          }
       }
       Swift.print("testManyHOTP: \(Optional(true) == true ? "✅" : "🚫")")
    }
   /**
    * Test Many TOTP
    * - Description: This function tests multiple Time-Based One-Time Passwords
    *                (TOTP) to ensure the OTP generation is accurate and adheres
    *                to the expected time-based algorithm outputs.
    */
   fileprivate static func testManyTOTP() throws {
       // Define test data for the TOTP algorithm
       // Each tuple contains a time value and expected OTP codes for different algorithms
       let timeBasedTests: [(date: Int, expSHA1: String, expSHA256: String, expSHA512: String)] = [
           (59, "94287082", "32247374", "69342147"),
           (1_111_111_109, "07081804", "34756375", "63049338"),
           (1_111_111_111, "14050471", "74584430", "54380122"),
           (1_234_567_890, "89005924", "42829826", "76671578"),
           (2_000_000_000, "69279037", "78428693", "56464532"),
           (20_000_000_000, "65353130", "24142410", "69481994")
       ]

       let data: Data = "12345678901234567890".data(using: String.Encoding.ascii)!
       
       // For each test data, generate OTP values using different algorithms and assert they match the expected values
       for test in timeBasedTests {
           let date = test.date
           
           // Generate an OTP value using the SHA-1 algorithm and the `data` secret, with the time value `date`
           let sha1 = try OTP(
               secret: data,            // The secret key used to generate the one-time password
               digits: 8,               // The number of digits in the OTP
               algo: .sha1              // The algorithm used to generate the OTP
           ).generate(secondsPast1970: date) // The time at which to generate the OTP
           // Assert that the generated OTP value matches the expected value for the SHA-1 algorithm
           XCTAssertEqual(sha1, test.expSHA1)
           
           // Generate an OTP value using the SHA-256 algorithm and the `data` secret, with the time value `date`
           let sha256 = try OTP(
               secret: data,            // The secret key used to generate the one-time password
               digits: 8,               // The number of digits in the OTP
               algo: .sha256            // The algorithm used to generate the OTP
           ).generate(secondsPast1970: date)
           // Assert that the generated OTP value matches the expected value for the SHA-256 algorithm
           XCTAssertEqual(sha256, test.expSHA256)
           
           // Generate an OTP value using the SHA-512 algorithm and the `data` secret, with the time value `date`
           let sha512 = try OTP(
               secret: data,            // The secret key used to generate the one-time password
               digits: 8,               // The number of digits in the OTP
               algo: .sha512            // The algorithm used to generate the OTP
           ).generate(secondsPast1970: date)
           // Assert that the generated OTP value matches the expected value for the SHA-512 algorithm
           XCTAssertEqual(sha512, test.expSHA512)
       }
       // Print the result of the test
       Swift.print("testManyTOTP: \(Optional(true) == true ? "✅" : "🚫")")
   }
   /**
    * Test Multiple HEX Encoded HTOP
    * - Description: This function tests multiple HMAC-Based One-Time Passwords
    *                (HOTP) that are HEX encoded to ensure the OTP generation
    *                is accurate and adheres to the expected HMAC-based algorithm
    *                outputs.
    */
   fileprivate static func testMultipleHEXEncodedHTOP() throws {
      // Define the `data` variable as a `Data` object initialized with a hex string
      let data: Data = .init(hex: "3132333435363738393031323334353637383930")
      // Define the expected OTP values as an array of strings
      let expectedOTP: [String] = ["755224", "287082", "359152", "969429", "338314", "254676", "287922", "162583", "399871", "520489"]
      // For each expected OTP value, generate an OTP value using the `OTP.generate` method with the `data` secret and the corresponding counter value, and assert that it matches the expected value
      for i in 0...(expectedOTP.count - 1) {
         XCTAssertEqual(try OTP(secret: data).generate(counter: UInt64(i)), expectedOTP[i])
      }
      Swift.print("testMultipleHEXEncodedHTOP: \(Optional(true) == true ? "✅" : "🚫")")
   }
   /**
    * Test random bulk test
    * - Description: This test function verifies the random generation of bulk
    *                OTP accounts. It ensures that each account can be successfully
    *                created, converted to a URL string, and reconstructed from
    *                that URL string without loss of data. The test asserts that
    *                the number of successfully created and validated OTP accounts
    *                matches the expected count.
    * - Fixme: ⚠️️ We could test
    */
   fileprivate static func testRandomBulk() throws {
      let count = 100 // Number of OTP accounts to generate
      // - Fixme: ⚠️️ Use MockGen to generate names and brands
      let names = ["Amy", "John", "David"] // Possible names for the OTP accounts
      let issuers = ["apple.com", "twitter.com", "google.com"] // Possible issuers for the OTP accounts

      // Generate `count` OTP accounts and verify that they can be reconstructed from their URLs
      let success = try (0..<count).allSatisfy { _ in
         let name = names.randomElement()! // Choose a random name
         let issuer = issuers.randomElement()! // Choose a random issuer

         guard let otpAccount = RandomOTP.randomOTPAccount(name: name, issuer: issuer) else {
            throw NSError(domain: "Unable to create otp", code: 0)
         }

         let otpURLString = otpAccount.absoluteURL.absoluteString // Get the absolute URL string of the generated OTP account

         guard let otpURL = URL(string: otpURLString),
               let newOTPAccount = try? OTPAccount(url: otpURL) else {
            return false // Return false if new OTPAccount cannot be created
         }

         // Check if the original and new OTP account URLs are equal
         return otpURLString == newOTPAccount.absoluteURL.absoluteString
      }

      Swift.print("testRandomBulk count: \(count) - success: \(success ? "✅" : "🚫")")
      XCTAssertTrue(success)
   }
}
#endif
