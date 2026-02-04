// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    internal enum Button {
      /// Confirm
      internal static let confirm = L10n.tr("Localizable", "common.button.confirm", fallback: "Confirm")
    }
    internal enum Error {
      /// Network error. Please try again
      internal static let network = L10n.tr("Localizable", "common.error.network", fallback: "Network error. Please try again")
      /// Localizable.strings
      ///  MultiFamily
      /// 
      ///  Generated & maintained for SwiftGen
      internal static let title = L10n.tr("Localizable", "common.error.title", fallback: "Error")
    }
  }
  internal enum Login {
    /// Forgot Password
    internal static let forgotPassword = L10n.tr("Localizable", "login.forgot_password", fallback: "Forgot Password")
    /// Login
    internal static let title = L10n.tr("Localizable", "login.title", fallback: "Login")
    internal enum Email {
      /// Email
      internal static let placeholder = L10n.tr("Localizable", "login.email.placeholder", fallback: "Email")
    }
    internal enum Error {
      /// Incorrect account or password
      internal static let invalid = L10n.tr("Localizable", "login.error.invalid", fallback: "Incorrect account or password")
    }
    internal enum Password {
      /// Password
      internal static let placeholder = L10n.tr("Localizable", "login.password.placeholder", fallback: "Password")
    }
  }
  internal enum Register {
    /// Register failed. Please try again
    internal static let error = L10n.tr("Localizable", "register.error", fallback: "Register failed. Please try again")
    /// Register
    internal static let title = L10n.tr("Localizable", "register.title", fallback: "Register")
    internal enum ConfirmPassword {
      /// Confirm password
      internal static let placeholder = L10n.tr("Localizable", "register.confirm_password.placeholder", fallback: "Confirm password")
      /// Confirm Password
      internal static let title = L10n.tr("Localizable", "register.confirm_password.title", fallback: "Confirm Password")
    }
    internal enum Country {
      /// Country
      internal static let title = L10n.tr("Localizable", "register.country.title", fallback: "Country")
    }
    internal enum Email {
      /// Email
      internal static let placeholder = L10n.tr("Localizable", "register.email.placeholder", fallback: "Email")
      /// Email
      internal static let title = L10n.tr("Localizable", "register.email.title", fallback: "Email")
    }
    internal enum Name {
      /// Name
      internal static let placeholder = L10n.tr("Localizable", "register.name.placeholder", fallback: "Name")
      /// Name
      internal static let title = L10n.tr("Localizable", "register.name.title", fallback: "Name")
    }
    internal enum Option {
      /// Option
      internal static let placeholder = L10n.tr("Localizable", "register.option.placeholder", fallback: "Option")
    }
    internal enum Password {
      /// Password
      internal static let placeholder = L10n.tr("Localizable", "register.password.placeholder", fallback: "Password")
      /// Password
      internal static let title = L10n.tr("Localizable", "register.password.title", fallback: "Password")
    }
    internal enum Phone {
      /// Phone
      internal static let title = L10n.tr("Localizable", "register.phone.title", fallback: "Phone")
    }
    internal enum Privacy {
      /// https://example.com/privacy
      internal static let link = L10n.tr("Localizable", "register.privacy.link", fallback: "https://example.com/privacy")
    }
    internal enum Terms {
      /// https://example.com/terms
      internal static let link = L10n.tr("Localizable", "register.terms.link", fallback: "https://example.com/terms")
      ///  and that you have read our 
      internal static let middle = L10n.tr("Localizable", "register.terms.middle", fallback: " and that you have read our ")
      /// By clicking Register, you agree to our 
      internal static let `prefix` = L10n.tr("Localizable", "register.terms.prefix", fallback: "By clicking Register, you agree to our ")
      /// Privacy Policy
      internal static let privacy = L10n.tr("Localizable", "register.terms.privacy", fallback: "Privacy Policy")
      /// Terms & Conditions
      internal static let terms = L10n.tr("Localizable", "register.terms.terms", fallback: "Terms & Conditions")
    }
  }
  internal enum Verify {
    /// Verification code has been sent to
    internal static let content = L10n.tr("Localizable", "verify.content", fallback: "Verification code has been sent to")
    /// Register Verify
    internal static let title = L10n.tr("Localizable", "verify.title", fallback: "Register Verify")
    internal enum Button {
      /// Resend Verify Code
      internal static let resend = L10n.tr("Localizable", "verify.button.resend", fallback: "Resend Verify Code")
      /// Verify
      internal static let verify = L10n.tr("Localizable", "verify.button.verify", fallback: "Verify")
    }
    internal enum Code {
      /// Verify Code
      internal static let placeholder = L10n.tr("Localizable", "verify.code.placeholder", fallback: "Verify Code")
    }
    internal enum Success {
      /// You can login now
      internal static let content = L10n.tr("Localizable", "verify.success.content", fallback: "You can login now")
      /// Register Success
      internal static let title = L10n.tr("Localizable", "verify.success.title", fallback: "Register Success")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
