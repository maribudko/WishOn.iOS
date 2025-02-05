// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Here you can provide some information about yourself, if you'd like to!
  internal static let aboutWisherPromt = L10n.tr("Localizable", "aboutWisherPromt", fallback: "Here you can provide some information about yourself, if you'd like to!")
  /// Localizable.strings
  ///   WishOn
  /// 
  ///   Created by Mari Budko on 28.11.2024.
  internal static let addNewWishlist = L10n.tr("Localizable", "Add New Wishlist", fallback: "Add New Wishlist")
  /// WishOn
  internal static let appName = L10n.tr("Localizable", "appName", fallback: "WishOn")
  /// Filter
  internal static let filter = L10n.tr("Localizable", "Filter", fallback: "Filter")
  /// Hello, Wisher!
  internal static let helloWisher = L10n.tr("Localizable", "helloWisher", fallback: "Hello, Wisher!")
  /// My Christmas List
  internal static let myChristmasList = L10n.tr("Localizable", "My Christmas List", fallback: "My Christmas List")
  /// New wishlist
  internal static let newWishlist = L10n.tr("Localizable", "New wishlist", fallback: "New wishlist")
  /// To Give
  internal static let toGive = L10n.tr("Localizable", "toGive", fallback: "To Give")
  /// Start your first WishList!
  /// And make your dreams come true!
  internal static let wishListEmptyView = L10n.tr("Localizable", "wishListEmptyView", fallback: "Start your first WishList!\nAnd make your dreams come true!")
  /// Wishlists name
  internal static let wishlistsName = L10n.tr("Localizable", "Wishlists name", fallback: "Wishlists name")
  /// WishOn
  internal static let wishOn = L10n.tr("Localizable", "WishOn", fallback: "WishOn")
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
