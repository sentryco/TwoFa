import SwiftUI

#Preview {
   let url: URL = .init(string: "otpauth://hotp/test?secret=6UAOpz+x3dsNrQ==&algorithm=SHA512&digits=6&counter=1")!
   let account: OTPAccount = try! .init(url: url)
   return OTPArc(account: account)
}
