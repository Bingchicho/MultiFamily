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
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "common.button.cancel", fallback: "Cancel")
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
    internal enum Notice {
      /// Notice
      internal static let title = L10n.tr("Localizable", "common.notice.title", fallback: "Notice")
    }
  }
  internal enum Detail {
    internal enum Alert {
      internal enum Remove {
        /// Remove the lock from this site?
        internal static let content = L10n.tr("Localizable", "detail.alert.remove.content", fallback: "Remove the lock from this site?")
        /// Remove Lock?
        internal static let title = L10n.tr("Localizable", "detail.alert.remove.title", fallback: "Remove Lock?")
      }
    }
    internal enum AutoLock {
      /// Auto Lock:
      internal static let title = L10n.tr("Localizable", "detail.auto_lock.title", fallback: "Auto Lock:")
    }
    internal enum Battery {
      /// battery:
      internal static let title = L10n.tr("Localizable", "detail.battery.title", fallback: "battery:")
    }
    internal enum Beep {
      /// Beep:
      internal static let title = L10n.tr("Localizable", "detail.beep.title", fallback: "Beep:")
    }
    internal enum Bt {
      internal enum Adv {
        /// BLE Adv:
        internal static let title = L10n.tr("Localizable", "detail.bt.adv.title", fallback: "BLE Adv:")
      }
      internal enum TxPower {
        /// BLE Power:
        internal static let title = L10n.tr("Localizable", "detail.bt.tx_power.title", fallback: "BLE Power:")
      }
    }
    internal enum Button {
      internal enum Lock {
        /// Lock
        internal static let title = L10n.tr("Localizable", "detail.button.lock.title", fallback: "Lock")
      }
      internal enum More {
        /// More
        internal static let title = L10n.tr("Localizable", "detail.button.more.title", fallback: "More")
      }
      internal enum Remove {
        /// Remove
        internal static let title = L10n.tr("Localizable", "detail.button.remove.title", fallback: "Remove")
      }
      internal enum Sync {
        /// Sync
        internal static let title = L10n.tr("Localizable", "detail.button.sync.title", fallback: "Sync")
      }
      internal enum Unlock {
        /// Unlock
        internal static let title = L10n.tr("Localizable", "detail.button.unlock.title", fallback: "Unlock")
      }
    }
    internal enum Hight {
      /// Hight
      internal static let title = L10n.tr("Localizable", "detail.hight.title", fallback: "Hight")
    }
    internal enum Low {
      /// Low
      internal static let title = L10n.tr("Localizable", "detail.low.title", fallback: "Low")
    }
    internal enum Middle {
      /// Middle
      internal static let title = L10n.tr("Localizable", "detail.middle.title", fallback: "Middle")
    }
    internal enum Off {
      /// OFF
      internal static let title = L10n.tr("Localizable", "detail.off.title", fallback: "OFF")
    }
    internal enum On {
      /// ON
      internal static let title = L10n.tr("Localizable", "detail.on.title", fallback: "ON")
    }
    internal enum Tab {
      internal enum Authorized {
        /// Authorized
        internal static let title = L10n.tr("Localizable", "detail.tab.authorized.title", fallback: "Authorized")
      }
      internal enum Black {
        /// BlackList
        internal static let title = L10n.tr("Localizable", "detail.tab.black.title", fallback: "BlackList")
      }
      internal enum History {
        /// History
        internal static let title = L10n.tr("Localizable", "detail.tab.history.title", fallback: "History")
      }
    }
  }
  internal enum Forgotpassword {
    /// Forgot Password
    internal static let title = L10n.tr("Localizable", "forgotpassword.title", fallback: "Forgot Password")
    internal enum Button {
      /// Verify
      internal static let getcode = L10n.tr("Localizable", "forgotpassword.button.getcode", fallback: "Verify")
      /// Resend Verify Code
      internal static let resend = L10n.tr("Localizable", "forgotpassword.button.resend", fallback: "Resend Verify Code")
    }
    internal enum Code {
      /// Verify Code error, Please try again
      internal static let error = L10n.tr("Localizable", "forgotpassword.code.error", fallback: "Verify Code error, Please try again")
      /// Verify Code
      internal static let placeholder = L10n.tr("Localizable", "forgotpassword.code.placeholder", fallback: "Verify Code")
      /// Resend Verify Code(%@s)
      internal static func resend(_ p1: Any) -> String {
        return L10n.tr("Localizable", "forgotpassword.code.resend", String(describing: p1), fallback: "Resend Verify Code(%@s)")
      }
      /// Verify Code is send to %@
      internal static func success(_ p1: Any) -> String {
        return L10n.tr("Localizable", "forgotpassword.code.success", String(describing: p1), fallback: "Verify Code is send to %@")
      }
    }
    internal enum ConfirmPassword {
      /// Confirm Password
      internal static let title = L10n.tr("Localizable", "forgotpassword.confirm_password.title", fallback: "Confirm Password")
    }
    internal enum Email {
      /// Email
      internal static let placeholder = L10n.tr("Localizable", "forgotpassword.email.placeholder", fallback: "Email")
    }
    internal enum Password {
      /// Password
      internal static let title = L10n.tr("Localizable", "forgotpassword.password.title", fallback: "Password")
    }
    internal enum Success {
      /// You can login now
      internal static let content = L10n.tr("Localizable", "forgotpassword.success.content", fallback: "You can login now")
      /// Change Password Success
      internal static let title = L10n.tr("Localizable", "forgotpassword.success.title", fallback: "Change Password Success")
    }
  }
  internal enum History {
    internal enum Empty {
      /// There is no event yet
      internal static let content = L10n.tr("Localizable", "history.empty.content", fallback: "There is no event yet")
      /// No Event history
      internal static let title = L10n.tr("Localizable", "history.empty.title", fallback: "No Event history")
    }
  }
  internal enum Home {
    /// Lock
    internal static let title = L10n.tr("Localizable", "home.title", fallback: "Lock")
    internal enum Button {
      /// Add lock
      internal static let addLock = L10n.tr("Localizable", "home.button.add_lock", fallback: "Add lock")
      internal enum Sync {
        /// Sync
        internal static let title = L10n.tr("Localizable", "home.button.sync.title", fallback: "Sync")
      }
    }
    internal enum Empty {
      /// There is no lock yet
      internal static let content = L10n.tr("Localizable", "home.empty.content", fallback: "There is no lock yet")
      /// No Lock
      internal static let title = L10n.tr("Localizable", "home.empty.title", fallback: "No Lock")
    }
    internal enum Synced {
      /// Synced
      internal static let title = L10n.tr("Localizable", "home.synced.title", fallback: "Synced")
    }
    internal enum Unsynced {
      /// Unsynced
      internal static let title = L10n.tr("Localizable", "home.unsynced.title", fallback: "Unsynced")
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
  internal enum Profile {
    /// Update failed. Please try again
    internal static let error = L10n.tr("Localizable", "profile.error", fallback: "Update failed. Please try again")
    /// Profile
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Profile")
    internal enum Alert {
      internal enum ChangePassword {
        /// Enter your new Password
        internal static let content = L10n.tr("Localizable", "profile.alert.change_password.content", fallback: "Enter your new Password")
        /// Change Password
        internal static let title = L10n.tr("Localizable", "profile.alert.change_password.title", fallback: "Change Password")
        internal enum ConfirmPassword {
          /// Confirm Password
          internal static let placeholder = L10n.tr("Localizable", "profile.alert.change_password.confirm_password.placeholder", fallback: "Confirm Password")
        }
        internal enum Error {
          /// Password do not match
          internal static let notMatch = L10n.tr("Localizable", "profile.alert.change_password.error.not_match", fallback: "Password do not match")
        }
        internal enum NewPassword {
          /// New Password
          internal static let placeholder = L10n.tr("Localizable", "profile.alert.change_password.new_password.placeholder", fallback: "New Password")
        }
        internal enum OldPassword {
          /// Old Password
          internal static let placeholder = L10n.tr("Localizable", "profile.alert.change_password.old_password.placeholder", fallback: "Old Password")
        }
      }
      internal enum DeleteAccount {
        /// Permanently delete your account? The account will no longer be available, and all data in the account will be permanently delete
        internal static let content = L10n.tr("Localizable", "profile.alert.delete_account.content", fallback: "Permanently delete your account? The account will no longer be available, and all data in the account will be permanently delete")
        /// Failed to delete account
        internal static let fail = L10n.tr("Localizable", "profile.alert.delete_account.fail", fallback: "Failed to delete account")
        /// Delete Account
        internal static let title = L10n.tr("Localizable", "profile.alert.delete_account.title", fallback: "Delete Account")
        internal enum Fail {
          /// Due to the incomplete card return process, you are unable to delete your account. Please contact technical support for assistance
          internal static let content = L10n.tr("Localizable", "profile.alert.delete_account.fail.content", fallback: "Due to the incomplete card return process, you are unable to delete your account. Please contact technical support for assistance")
        }
      }
      internal enum EditMobile {
        /// Enter your mobile
        internal static let content = L10n.tr("Localizable", "profile.alert.edit_mobile.content", fallback: "Enter your mobile")
        /// Mobile
        internal static let placeholder = L10n.tr("Localizable", "profile.alert.edit_mobile.placeholder", fallback: "Mobile")
        /// Edit Mobile
        internal static let title = L10n.tr("Localizable", "profile.alert.edit_mobile.title", fallback: "Edit Mobile")
      }
      internal enum EditName {
        /// Enter your name
        internal static let content = L10n.tr("Localizable", "profile.alert.edit_name.content", fallback: "Enter your name")
        /// Name
        internal static let placeholder = L10n.tr("Localizable", "profile.alert.edit_name.placeholder", fallback: "Name")
        /// Edit Name
        internal static let title = L10n.tr("Localizable", "profile.alert.edit_name.title", fallback: "Edit Name")
      }
      internal enum Logout {
        /// Are you sure you want to logout?
        internal static let content = L10n.tr("Localizable", "profile.alert.logout.content", fallback: "Are you sure you want to logout?")
        /// Logout
        internal static let title = L10n.tr("Localizable", "profile.alert.logout.title", fallback: "Logout")
      }
    }
    internal enum Button {
      /// Change Password
      internal static let changePassword = L10n.tr("Localizable", "profile.button.change_password", fallback: "Change Password")
      /// Delete Account
      internal static let deleteAccount = L10n.tr("Localizable", "profile.button.delete_account", fallback: "Delete Account")
      /// Edit
      internal static let edit = L10n.tr("Localizable", "profile.button.edit", fallback: "Edit")
      /// Logout
      internal static let logout = L10n.tr("Localizable", "profile.button.logout", fallback: "Logout")
    }
    internal enum Email {
      /// Email
      internal static let title = L10n.tr("Localizable", "profile.email.title", fallback: "Email")
    }
    internal enum Mobile {
      /// Mobile
      internal static let title = L10n.tr("Localizable", "profile.mobile.title", fallback: "Mobile")
    }
    internal enum Name {
      /// Name
      internal static let title = L10n.tr("Localizable", "profile.name.title", fallback: "Name")
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
  internal enum Site {
    /// Site
    internal static let title = L10n.tr("Localizable", "site.title", fallback: "Site")
  }
  internal enum Verify {
    /// Verification code has been sent to
    internal static let content = L10n.tr("Localizable", "verify.content", fallback: "Verification code has been sent to")
    /// Verify Code error, Please try again
    internal static let error = L10n.tr("Localizable", "verify.error", fallback: "Verify Code error, Please try again")
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
    internal enum Resend {
      /// Resend Verify Code (%ds)
      internal static func cooldown(_ p1: Int) -> String {
        return L10n.tr("Localizable", "verify.resend.cooldown", p1, fallback: "Resend Verify Code (%ds)")
      }
      /// Resend Verify Code error, Please try again
      internal static let error = L10n.tr("Localizable", "verify.resend.error", fallback: "Resend Verify Code error, Please try again")
      /// New Verify Code is send to %@
      internal static func success(_ p1: Any) -> String {
        return L10n.tr("Localizable", "verify.resend.success", String(describing: p1), fallback: "New Verify Code is send to %@")
      }
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
