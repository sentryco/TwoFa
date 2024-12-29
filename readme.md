[![Tests](https://github.com/sentryco/TwoFa/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/TwoFa/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/55316ce1-2cce-4173-ab3c-84ed7a82c5ea)](https://codebeat.co/projects/github-com-sentryco-twofa-main)

# TwoFa ⏳

> 2FA framework (One-time-password) (TOTP / HOTP)

### Description:
- It helps keep your online accounts secure by generating unique one-time passwords, which you use in combination with your other passwords to log into supporting websites.
- TOTP stands for Time-Based One-Time Password. This is a standardized method for generating a regularly-changing password that is based on a shared secret, ensuring that each code is unique.
- HOTP stands for HMAC-Based One-Time Password. Unlike TOTP, HOTP passwords are based on a counter mechanism and do not expire after a short period of time, making them suitable for situations where time-sync might not be possible.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Example](#example)
- [Resources](#resources)
- [Inspiration](#inspiration)
- [Library](#library)
- [Todo](#todo)

### Features:
- 📷 Easy setup via QR code, "otpauth://" URL, or manual entry
- 🔒 Secure storage of all data in encrypted form on the iOS keychain
- 🔄 Full support for time-based and counter-based one-time passwords as standardized in RFC 4226 and 6238

### Installation

To integrate TwoFa into your Xcode project using Swift Package Manager, add it as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/sentryco/TwoFa", branch: "main")
```

### Example:

From "OTP url" to "one time password"
```swift
let account = try? Account(url: URL(string: "otpauth://totp/test?secret=GEZDGNBV")!)
print(account?.currentPassword) // 123321
```

This code snippet uses a predefined secret key and generates a TOTP that changes every 30 seconds.

```swift
let totpGenerator = TOTPGenerator(secret: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", digits: 6, timeInterval: 30)
let totp = totpGenerator.generateOTP()
print("Generated TOTP: \(totp)")
```

The HOTP is generated using a counter, which should be incremented for each new OTP generation.

```swift
let hotpGenerator = HOTPGenerator(secret: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ", counter: 1)
let hotp = hotpGenerator.generateOTP()
print("Generated HOTP: \(hotp)")
```

Validating an OTP: This example demonstrates how to validate an OTP that a user might enter. This snippet checks if the provided OTP is valid for the given secret key.

```swift
let isValid = OTPValidator.validate(otp: "123456", secret: "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")
if isValid {
    print("OTP is valid.")
} else {
    print("OTP is invalid.")
}
```

### Resources:
- https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/Keychain.swift
- Hashable token: https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/PersistentToken.swift
- https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/KeychainStore.swift
- https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/TokenStore.swift
- More resources here: https://github.com/keyguardio/KeyGuard/issues/204
- https://en.wikipedia.org/wiki/HMAC-based_One-Time_Password
- https://www.microcosm.com/blog/hotp-totp-what-is-the-difference
- Hashable token: https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/PersistentToken.swift
- https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/KeychainStore.swift
- https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/TokenStore.swift
- QR: https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/ScanViewController.swift
- QR: https://github.com/mattrubin/Authenticator/blob/develop/Authenticator/Source/QRScanner.swift
- Circle graphic: https://github.com/calleluks/Tofu/blob/master/Tofu/CircularProgressView.swift
- Circle graphic: https://github.com/mattrubin/Authenticator/blob/develop/Authenticator/Source/ProgressRingView.swift
- Circle graphic: https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/CircleProgressView.swift
- cryptoKit has TOTP: https://developer.apple.com/forums/thread/120918
- collection of websites that support 2fa. https://2fa.directory a possible feature could be a small suggestion to add 2fa to your amazon.com login if non is present etc.
- Apple has a list of 2fa domains: https://github.com/apple/password-manager-resources/blob/main/quirks/websites-that-append-2fa-to-password.json
- Yubi, 2fa, fido2 website support list: https://dongleAuth.com
- Googles TOTP docs: https://github.com/google/google-authenticator/wiki/Key-Uri-Format

### Inspiration:
- Looks good: https://github.com/mattrubin/authenticator
- Limited progress: https://github.com/incipher/einmal
- Very good (HOTP TOTP: ) https://github.com/calleerlandsson/Tofu ✨(has many UnitTests) ✨
- HOTP TOTP: https://github.com/freeotp/freeotp-ios
- Has TOTP: https://github.com/keepassium/KeePassium
- TOTP: https://github.com/mssun/passforios
- Jubi key: Somewhere here: https://github.com/dkhamsing/open-source-ios-apps#password

### Library:
- https://github.com/lachlanbell/SwiftOTP (👍 looks interesting)
- https://github.com/SAP/gigya-swift-sdk/tree/main/GigyaSwift (for reference)
- https://github.com/mattrubin/OneTimePassword (for ref)
- Looks very easy to use: https://github.com/ericlewis/THOTP `let password = try? Password(url: URL(string: "otpauth://totp/test?secret=GEZDGNBV")!); print(password.currentPassword) // 123321`
- https://github.com/beemdevelopment/Aegis (has TOTP bulk importers etc, Android)
- Minimal TOTP code: https://github.com/keepassium/KeePassium/blob/master/KeePassiumLib/KeePassiumLib/db/totp/TOTPGenerator.swift

### Notes:
- Has url filtering: https://github.com/ericlewis/THOTP/blob/master/Sources/THOTP/Extensions/PasswordProtocol%2BURL.swift
- Can create OTP URI strings: https://stefansundin.github.io/2fa-qr/

### HOTP: Event-based One-Time Password
Event-based OTP (also called HOTP meaning HMAC-based One-Time Password) is the original One-Time Password algorithm and relies on two pieces of information. The first is the secret key, called the "seed", which is known only by the token and the server that validates submitted OTP codes. The second piece of information is the moving factor which, in event-based OTP, is a counter. The counter is stored in the token and on the server. The counter in the token increments when the button on the token is pressed, while the counter on the server is incremented only when an OTP is successfully validated.

To calculate an OTP the token feeds the counter into the HMAC algorithm using the token seed as the key. HOTP uses the SHA-1 hash function in the HMAC. This produces a 160-bit value which is then reduced down to the 6 (or 8) decimal digits displayed by the token.

### TOTP: Time-based One-Time Password
Time-based OTP (TOTP for short), is based on HOTP but where the moving factor is time instead of the counter. TOTP uses time in increments called the timestep, which is usually 30 or 60 seconds. This means that each OTP is valid for the duration of the timestep.

### Comparison
Both OTP schemes offer single-use codes but the key difference is that in HOTP a given OTP is valid until it is used, or until a subsequent OTP is used. In HOTP there are a number of valid "next OTP" codes. This is because the button on the token can be pressed, thus incrementing the counter on the token, without the resulting OTP being submitted to the validating server. For this reason, HOTP validating servers accept a range of OTPs. Specifically, they will accept an OTP that is generated by a counter that is within a set number of increments from the previous counter value stored on the server. This is range is referred to as the validation window. If the token counter is outside of the range allowed by the server, the validation fails and the token must be re-synchronised.

So clearly in HOTP there is a trade-off to make. The larger the validation window the less likely the chance of needing to re-sync the token with the server, which is inconvenient for the user. Importantly though, the larger the window the greater the chance of an adversary guessing one of the accepted OTPs through a brute-force attack.

Choosing between HOTP and TOTP purely from a security perspective clearly favours TOTP. Importantly, the validating server must be able to cope with potential for time-drift with TOTP tokens in order to minimise any impact on users.

There is also more choice of form-factor with TOTP tokens. Traditional key fob OTP tokens are getting smaller and Microcosm has now introduced the OTP Card - a credit card sized OTP token with EPD display. Cards can be a more convenient option as they can be stored with other cards in a wallet or purse, or in the back of a mobile phone case.
In contrast, in TOTP there is only one valid OTP at any given time - the one generated from the current UNIX time.

### Todo:
- Make xcode proj, add the graphtest code etc
- Add data tests: https://github.com/calleluks/Tofu/blob/master/TofuTests/DataTests.swift
- Add base32 support (base64 might be enough actually): https://github.com/lachlanbell/SwiftOTP/tree/master/SwiftOTP/Base32
- Improve archiving classes https://github.com/calleluks/Tofu/blob/master/Tofu/Keychain.swift
- Add ability to import google authenticator export qr format? Github has some code on this
- Bulk export of otp keys: https://github.com/iKenndac/Tofu/issues/38 and https://alexbakker.me/post/parsing-google-auth-export-qr-code.html
- More comprehensive URI parsing: https://github.com/freeotp/freeotp-ios/blob/master/FreeOTP/Token.swift
- More URI parsing: https://github.com/mattrubin/OneTimePassword/blob/develop/Sources/Token%2BURL.swift
- More uri unit-testing: https://github.com/freeotp/freeotp-ios/blob/master/FreeOTPTests/URI.swift
- More tests: https://github.com/mattrubin/OneTimePassword/blob/develop/Tests/GeneratorTests.swift
- Add the swift code for graphprogressview etc ✅
- Look for more ways of doing things better in the other projects 👈
- Add a Table of Contents: Given the length of your README, a table of contents at the beginning would help users navigate through the document.
- Add a "Getting Started" or "Installation" section: If your project requires any setup or installation, include a section that walks users through that process.
- Add a "Usage" or "Examples" section: Expand on your current "Example" section to provide more examples of how to use your project. 👈
- Is GraphProgressView still in use? Add the SwiftUI version of it? ✅
- **Unit Testing and Code Coverage**: More comprehensive testing and entropy in the tests. Improving the unit tests to cover more scenarios and edge cases would enhance the reliability of the code.
- **Error Handling**: There are multiple places in the code where error handling could be improved. For example, in OTPAccIniter.swift, the method validateHost throws an error if the host is not "hotp" or "totp", but it might be beneficial to handle different types of errors more gracefully or provide more detailed error messages.
- **Security and Encryption**: Given the nature of the application dealing with two-factor authentication, prioritizing the security aspects such as how secrets are handled or improving the cryptographic implementations would be crucial. For instance, ensuring that the generation of secrets in RandomOTP.swift is secure and adheres to best practices.
- **Refactoring and Modularization**: Some parts of the codebase could benefit from refactoring to improve modularity and reusability. For example, separating the URL building logic in AbsoluteURLBuilder.swift into more granular components could make the code easier to manage and test.
- **User Documentation**: Improving the README file to include more comprehensive guides on setup, usage, and contribution could make the project more accessible to new developers or users.
- Add more examples to the README
- Only add MockGen package for testing in the package.swift file
