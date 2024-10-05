import Foundation
/**
 * OTP error
 * - Description: The `OTPError` enum defines the types of errors that can occur when generating or validating a one-time password (OTP). These errors can be related to invalid digits, period, time, or URL used in the OTP generation process. Each case of the enum represents a different type of error, providing detailed information about the specific issue encountered.
 */
public enum OTPError: Error {
   /**
    * A case for when the number of digits in the OTP is invalid.
    * - Description: This error indicates that the number of digits provided for the OTP is not valid. The number of digits in an OTP is crucial for its security, as it determines the range of possible OTPs. An invalid number of digits could mean it is formatted incorrectly, out of range, or not adhering to the expected standards for OTP length.
    */
   case invalidDigits
   /**
    * A case for when the time period for which the OTP is valid is invalid.
    * - Description: This error indicates that the period value provided for the OTP is not valid. The period is essential for determining the lifespan of a Time-based One-Time Password (TOTP), and an invalid period could mean it is formatted incorrectly, out of range, or not adhering to the expected standards for time intervals.
    */
   case invalidPeriod
   /**
    * A case for when the time used to generate the OTP is invalid.
    * - Description: This error indicates that the time value provided to generate the OTP is not valid. The time value is crucial for time-based OTP algorithms, as it determines the validity and uniqueness of the OTP. An invalid time could mean it is formatted incorrectly, out of range, or not synchronized with the time server.
    */
   case invalidTime
   /**
    * A case for when the URL used to generate the OTP is invalid.
    * - Description: The URL is a standardized format for the OTP and must conform to specific criteria. If the URL does not meet these criteria, it is considered invalid. This error is thrown to indicate that the URL cannot be used to generate a valid OTP.
    * - Fixme: ⚠️️ Add rason cases as it's own enum
    * - Parameter reason: The reason why the URL is invalid.
    */
   case invalidURL(reason: String)
}
