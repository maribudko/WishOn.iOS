import SwiftUI
import UIKit
import WOCore
import WODesign
import WOResources

struct WishItemSheet: View {
    @Environment(\.openURL) private var openURL
    @State private var sheetWidth: CGFloat = 0
    @State private var sheetHeight: CGFloat = 0
    let wish: Wish

    private var contentWidth: CGFloat {
        max(sheetWidth - AppPaddings.padding16 * 2, 0)
    }

    private let sheetCornerRadius: CGFloat = 38

    var body: some View {
        VStack(alignment: .leading, spacing: AppPaddings.padding16) {
                wishImage
                    .frame(width: contentWidth, height: 280)
                    .background(HomeGridPalette.coverPlaceholder)
                    .compositingGroup()
                    .clipShape(RoundedRectangle(cornerRadius: sheetCornerRadius, style: .continuous))

            Text(wish.name)
                .font(.title2.weight(.bold))
                .foregroundColor(HomeGridPalette.title)
                .frame(width: contentWidth, alignment: .leading)

            if let price = WishDisplay.price(for: wish) {
                Text(price)
                    .font(.title3.weight(.bold))
                    .foregroundColor(HomeGridPalette.title)
                    .frame(width: contentWidth, alignment: .leading)
            }

            if let url = WishDisplay.websiteURL(for: wish.link) {
                Button {
                    openURL(url)
                } label: {
                    Label(L10n.openSite, systemImage: SFSymbols.link.name)
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppPaddings.padding14)
                        .background(HomeGridPalette.accent)
                        .foregroundColor(HomeGridPalette.onAccent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius, style: .continuous))
                }
                .frame(width: contentWidth)
            }
        }
        .padding(AppPaddings.padding16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: WishSheetSizeKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(WishSheetSizeKey.self) { size in
            sheetWidth = size.width
            sheetHeight = size.height
        }
        .background(HomeGridPalette.background)
        .preferredColorScheme(.light)
        .presentationDetents([.height(max(sheetHeight, 1))])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private var wishImage: some View {
        if let url = WishDisplay.websiteURL(for: wish.image) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholder
                }
            }
        } else if let localURL = WishListImageStore.fileURL(for: wish.image),
                  let localImage = UIImage(contentsOfFile: localURL.path) {
            Image(uiImage: localImage)
                .resizable()
                .scaledToFill()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(asset: Asset.blankImage)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .padding(AppPaddings.padding26)
            .foregroundColor(HomeGridPalette.accent)
    }
}

private struct WishSheetSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(width: max(value.width, next.width), height: max(value.height, next.height))
    }
}

enum WishDisplay {
    static func websiteURL(for raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard UrlValidator().validate(trimmed) else { return nil }
        return URL(string: trimmed)
    }

    static func price(for wish: Wish) -> String? {
        guard let price = wish.price else { return nil }
        let amount = price.formatted(.number.precision(.fractionLength(0...2)))
        switch wish.currency {
        case L10n.usd:
            return "$\(amount)"
        case L10n.eur:
            return "€\(amount)"
        case L10n.uah:
            return "\(amount) \(L10n.uah)"
        default:
            return wish.currency.isEmpty ? amount : "\(amount) \(wish.currency)"
        }
    }
}
