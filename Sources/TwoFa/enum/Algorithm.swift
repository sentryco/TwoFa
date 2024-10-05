import Foundation
/**
 * Hash algorithm to use for generation of `one-time-password`
 * - Description: The `Algorithm` enum defines the cryptographic hash functions that can be used to generate a one-time password (OTP). Each case of the enum represents a different hash function, with varying levels of security and output sizes.
 * - Remark: These algorithms are officially supported by Google Authenticator.
 * - Note: The `SHA-1`, `SHA-256`, and `SHA-512 hash functions are all part of the SHA (Secure Hash Algorithm) family of cryptographic hash functions. The main difference between them is the size of the output they produce and the number of rounds they use to generate the hash.
 */
public enum Algorithm: String {
   /**
    * SHA-1 produces a 160-bit hash value and uses 80 rounds of hashing.
    * - Description: SHA-1 is a legacy hash function that is no longer recommended for security-sensitive applications. However, it is still used in some contexts for backward compatibility.
    * - Note: It is considered to be less secure than SHA-256 and SHA-512 due to its smaller output size and the discovery of theoretical attacks that can break it.
    */
   case sha1
   /**
    * SHA-256 produces a 256-bit hash value and uses 64 rounds of hashing. 
    * - Description: SHA-256 is a cryptographic hash function that provides a good balance between performance and security. It is part of the SHA-2 family and is commonly used for security applications and protocols, including SSL, TLS, and cryptocurrency blockchains.
    * - Note: It is currently considered to be a secure hash function and is widely used in various applications.
    */
   case sha256
   /**
    * SHA-512 produces a 512-bit hash value and uses 80 rounds of hashing. 
    * - Description: SHA-512 is a cryptographic hash function that provides the highest level of security among the SHA-2 family. It is designed for the most security-sensitive applications due to its large output size and the increased number of rounds it uses for hashing.
    * - Note: It is a more secure hash function than SHA-256 due to its larger output size and the increased number of rounds it uses.
    * - Note: It is often used in applications that require a high level of security, such as digital signatures and password storage.
    */
   case sha512
}
