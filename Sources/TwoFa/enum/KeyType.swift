import Foundation
/**
 * A type that represents the `query-item-keys` used for decoding URI's
 * - Remark: These are the different components that make up the `OTP` URI
 * - Note: More doc here: https://github.com/google/google-authenticator/wiki/Key-Uri-Format
 */
public enum KeyType: CodingKey {
   /**
    * A case for the issuer of the OTP
    * - Description: The issuer is the entity that provides the OTP. This
    *                could be a bank, a social media platform, or any other
    *                service that requires secure user authentication.
    */
   case issuer
   /**
    * A case for the image associated with the OTP
    * - Description: The image is a visual representation associated with the
    *                OTP. This could be an icon, a QR code, or any other
    *                image that helps identify the OTP or the issuer. It
    *                enhances user experience by providing a visual cue.
    * - Fixme: ⚠️️ what is the image? an icon or qr or? or something else? check  google
    */
   case image
   /**
    * A case for the secret key used to generate the OTP
    * - Description: The secret key is a unique piece of data that is used to
    *                generate the OTP. It is known only to the user and the
    *                system, and it is used in the OTP generation algorithm to
    *                create a unique and unpredictable OTP each time.
    */
   case secret
   /**
    * A case for the number of digits in the OTP
    * - Description: The digits represent the length of the OTP. This is the
    *                number of numerical digits that the OTP will contain. A
    *                higher number of digits means a higher level of security,
    *                but it may be harder for users to remember.
    */
   case digits
   /**
    * A case for the hash algorithm used to generate the OTP
    * - Description: The algorithm specifies the cryptographic hash function
    *                used to generate the OTP. It determines how the secret
    *                key is transformed into a one-time password. Supported
    *                algorithms include SHA-1, SHA-256, and SHA-512, with
    *                SHA-1 being the least secure and SHA-512 being the most
    *                secure.
    */
   case algorithm
   /**
    * A case for the time period for which the OTP is valid
    * - Description: The period defines the length of time for which a
    *                Time-based One-Time Password (TOTP) is valid. After this
    *                time, a new OTP will be generated. The period is
    *                typically set to 30 seconds, aligning with the common
    *                TOTP standard.
    */
   case period
   /**
    * A case for the counter value used to generate the OTP
    * - Description: The counter is used in the HMAC-based One-Time Password
    *                (HOTP) algorithm as a moving factor that increments
    *                with each password generation. It ensures that each
    *                password is unique by providing a dynamic component to
    *                the password generation process.
    */
   case counter
}
