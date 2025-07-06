// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Here you can provide some information about yourself, if you'd like to!
  public static let aboutWisherPromt = L10n.tr("Localizable", "aboutWisherPromt", fallback: "Here you can provide some information about yourself, if you'd like to!")
  /// Localizable.strings
  ///   WishOn
  /// 
  ///   Created by Mari Budko on 28.11.2024.
  public static let addNewWishlist = L10n.tr("Localizable", "Add New Wishlist", fallback: "Add New Wishlist")
  /// Login with Apple
  public static let appleLoginLabel = L10n.tr("Localizable", "apple_login_label", fallback: "Login with Apple")
  /// WishOn
  public static let appName = L10n.tr("Localizable", "appName", fallback: "WishOn")
  /// Attention!
  public static let attention = L10n.tr("Localizable", "Attention", fallback: "Attention!")
  /// This field cannot be empty.
  public static let cannotBeEmpty = L10n.tr("Localizable", "cannot_be_empty", fallback: "This field cannot be empty.")
  /// Create
  public static let createLabel = L10n.tr("Localizable", "create_label", fallback: "Create")
  /// Date
  public static let dateHint = L10n.tr("Localizable", "date_hint", fallback: "Date")
  /// Description
  public static let descriptionHint = L10n.tr("Localizable", "description_hint", fallback: "Description")
  /// Done
  public static let doneLabel = L10n.tr("Localizable", "done_label", fallback: "Done")
  /// EUR
  public static let eur = L10n.tr("Localizable", "EUR", fallback: "EUR")
  /// Please, fill all fields correctly.
  public static let fillAllFields = L10n.tr("Localizable", "fill_all_fields", fallback: "Please, fill all fields correctly.")
  /// Filter
  public static let filter = L10n.tr("Localizable", "Filter", fallback: "Filter")
  /// Login with Google
  public static let googleLoginLabel = L10n.tr("Localizable", "google_login_label", fallback: "Login with Google")
  /// Hello, Wisher!
  public static let helloWisher = L10n.tr("Localizable", "helloWisher", fallback: "Hello, Wisher!")
  /// You entered incorrect price value! Please, check it and try again.
  public static let incorrectPriceAlert = L10n.tr("Localizable", "incorrect_price_alert", fallback: "You entered incorrect price value! Please, check it and try again.")
  /// Oops! That doesn’t look like a valid price value.
  public static let invalidPrice = L10n.tr("Localizable", "invalid_price", fallback: "Oops! That doesn’t look like a valid price value.")
  /// Oops! That doesn’t look like a valid URL.
  public static let invalidUrl = L10n.tr("Localizable", "invalid_url", fallback: "Oops! That doesn’t look like a valid URL.")
  /// Link cannot be empty.
  public static let linkCannotBeEmpty = L10n.tr("Localizable", "link_cannot_be_empty", fallback: "Link cannot be empty.")
  /// Link
  public static let linkHint = L10n.tr("Localizable", "link_hint", fallback: "Link")
  /// Link value is incorrect.
  public static let linkIsIncorrect = L10n.tr("Localizable", "link_is_incorrect", fallback: "Link value is incorrect.")
  /// My Christmas List
  public static let myChristmasList = L10n.tr("Localizable", "My Christmas List", fallback: "My Christmas List")
  /// Name should contain at least 2 characters.
  public static let nameCannotBeEmpty = L10n.tr("Localizable", "name_cannot_be_empty", fallback: "Name should contain at least 2 characters.")
  /// Name
  public static let nameHint = L10n.tr("Localizable", "name_hint", fallback: "Name")
  /// New wishlist
  public static let newWishlist = L10n.tr("Localizable", "New wishlist", fallback: "New wishlist")
  /// New wishlist
  public static let newWishlistLbl = L10n.tr("Localizable", "new_wishlist_lbl", fallback: "New wishlist")
  /// No wishes yet. Tap the button below to add one!
  public static let noWishesLabel = L10n.tr("Localizable", "no_wishes_label", fallback: "No wishes yet. Tap the button below to add one!")
  /// Ok
  public static let okLabel = L10n.tr("Localizable", "ok_label", fallback: "Ok")
  /// Price
  public static let priceHint = L10n.tr("Localizable", "price_hint", fallback: "Price")
  /// Price value is incorrect.
  public static let priceIsIncorrect = L10n.tr("Localizable", "price_is_incorrect", fallback: "Price value is incorrect.")
  /// Select a Date
  public static let selectDateHint = L10n.tr("Localizable", "select_date_hint", fallback: "Select a Date")
  ///  
  public static let spaceText = L10n.tr("Localizable", "space_text", fallback: " ")
  /// Done!
  public static let successMessage = L10n.tr("Localizable", "success_message", fallback: "Done!")
  /// To Give
  public static let toGive = L10n.tr("Localizable", "toGive", fallback: "To Give")
  /// UAH
  public static let uah = L10n.tr("Localizable", "UAH", fallback: "UAH")
  /// USD
  public static let usd = L10n.tr("Localizable", "USD", fallback: "USD")
  /// Your wishes (%d)
  public static func wishesCountLabel(_ p1: Int) -> String {
    return L10n.tr("Localizable", "wishes_count_label", p1, fallback: "Your wishes (%d)")
  }
  /// WishList Details
  public static let wishlistDetails = L10n.tr("Localizable", "wishlist_details", fallback: "WishList Details")
  /// Start your first WishList!
  /// And make your dreams come true!
  public static let wishListEmptyView = L10n.tr("Localizable", "wishListEmptyView", fallback: "Start your first WishList!\nAnd make your dreams come true!")
  /// Wishlists name
  public static let wishlistsName = L10n.tr("Localizable", "Wishlists name", fallback: "Wishlists name")
  /// WishOn
  public static let wishOn = L10n.tr("Localizable", "WishOn", fallback: "WishOn")
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

