//
//  WishListCardView.swift
//  WishOn
//
//  Created by Mari Budko on 29.11.2024.
//

import SwiftUI
import WOResources

public struct WishListCardViewState {
    public let imageName: String
    public let name: String
    /// Event date or wish-count meta line shown under the title.
    public let subtitle: String

    public init(imageName: String, name: String, subtitle: String) {
        self.imageName = imageName
        self.name = name
        self.subtitle = subtitle
    }

    /// Backward-compatible alias used by older call sites / previews.
    public init(imageName: String, name: String, formattedDate: String) {
        self.init(imageName: imageName, name: name, subtitle: formattedDate)
    }
}

public struct WishListCardView: View {
    public let viewState: WishListCardViewState

    public init(viewState: WishListCardViewState) {
        self.viewState = viewState
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverImage
                .frame(maxWidth: .infinity)
                .aspectRatio(AppDimensions.wishListHomeGridCoverAspectRatio, contentMode: .fit)
                .clipped()

            VStack(alignment: .leading, spacing: AppPaddings.padding5) {
                Text(viewState.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(HomeGridPalette.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(viewState.subtitle)
                    .font(.caption)
                    .foregroundColor(HomeGridPalette.subtitle)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppPaddings.padding10)
            .padding(.vertical, AppPaddings.padding10)
        }
        .background(HomeGridPalette.card)
        .clipShape(RoundedRectangle(cornerRadius: AppRadiuses.radius12, style: .continuous))
        .shadow(
            color: AppShadows.homeGridCard.color,
            radius: AppShadows.homeGridCard.radius,
            x: AppShadows.homeGridCard.x,
            y: AppShadows.homeGridCard.y
        )
    }

    @ViewBuilder
    private var coverImage: some View {
        ZStack {
            HomeGridPalette.coverPlaceholder

            if let url = coverURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderIcon
                    case .empty:
                        ProgressView()
                            .tint(HomeGridPalette.accent)
                    @unknown default:
                        placeholderIcon
                    }
                }
            } else if !viewState.imageName.isEmpty {
                tileIcon(systemName: outlineSymbolName(viewState.imageName))
            } else {
                placeholderIcon
            }
        }
    }

    private var placeholderIcon: some View {
        tileIcon(systemName: SFSymbols.giftOutline.name)
    }

    private func tileIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(
                width: AppDimensions.wishListHomeGridTileIconSize,
                height: AppDimensions.wishListHomeGridTileIconSize
            )
            .foregroundColor(HomeGridPalette.accent)
            .symbolRenderingMode(.monochrome)
    }

    /// Prefer outline SF Symbols so tile icons stay stroke-only (not solid fills).
    private func outlineSymbolName(_ name: String) -> String {
        if name.hasSuffix(".fill") {
            return String(name.dropLast(5))
        }
        return name
    }

    private var coverURL: URL? {
        let raw = viewState.imageName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard raw.hasPrefix("http://") || raw.hasPrefix("https://") else { return nil }
        return URL(string: raw)
    }
}

#Preview {
    let viewState = WishListCardViewState(
        imageName: SFSymbols.giftOutline.name,
        name: "Birthday",
        subtitle: DateFormatter.shortDate.string(from: Date())
    )
    WishListCardView(viewState: viewState)
        .frame(width: AppDimensions.wishListCardWidthMax + AppPaddings.padding26)
        .padding()
        .background(HomeGridPalette.background)
}
