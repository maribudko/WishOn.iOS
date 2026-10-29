import SwiftUI
import WOResources
import WODesign
import WOCore
import WONewWishListFeature
import DependencyInjection
import WOToGiveFeature
import Swinject

public struct WishListsState {
    public let addNewWishlistButton: NavigationLinkButtonViewState
    public let toGiveButton: NavigationLinkButtonViewState
    public let wishLists: [WishList]
    public let calendarIcon: IconViewState
    public let profileIcon: IconViewState
    public let emptyListIcon: IconViewState
    
    public init(addNewWishlistButton: NavigationLinkButtonViewState, toGiveButton: NavigationLinkButtonViewState, wishLists: [WishList], calendarIcon: IconViewState, profileIcon: IconViewState, emptyListIcon: IconViewState) {
        self.addNewWishlistButton = addNewWishlistButton
        self.toGiveButton = toGiveButton
        self.wishLists = wishLists
        self.calendarIcon = calendarIcon
        self.profileIcon = profileIcon
        self.emptyListIcon = emptyListIcon
    }
}

private enum HomeTab: Hashable {
    case wishlists
    case toGive
}

public struct WishListRootView: View {
    private var isAuthorized = false
    @ObservedObject private var viewModel: WishListViewModel
    @State private var selectedTab: HomeTab = .wishlists
    @State private var isCreatingWishList = false
    @State private var newWishListViewModel: NewWishListViewModel?
    @State private var isShowingWishList = false
    @State private var openedWishListViewModel: NewWishListViewModel?

    private let columns = [
        GridItem(.flexible(), spacing: AppDimensions.wishListHomeGridSpacing),
        GridItem(.flexible(), spacing: AppDimensions.wishListHomeGridSpacing)
    ]
    
    public init(isAuthorized: Bool = false, viewModel: WishListViewModel) {
        self.isAuthorized = isAuthorized
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, AppPaddings.padding16)

                    tabBar
                        .padding(.horizontal, AppPaddings.padding16)
                        .padding(.top, AppPaddings.padding8)

                    Group {
                        switch selectedTab {
                        case .wishlists:
                            if viewModel.viewState.wishLists.isEmpty {
                                emptyState
                            } else {
                                homeGrid
                            }
                        case .toGive:
                            toGiveTabContent
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }

                if selectedTab == .wishlists {
                    addWishlistFAB
                        .padding(.trailing, AppPaddings.padding16)
                        .padding(.bottom, AppPaddings.padding20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(HomeGridPalette.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .preferredColorScheme(.light)
            .onAppear {
                viewModel.loadWishLists()
            }
            .environmentObject(viewModel)
        }
    }

    private var header: some View {
        HStack {
            Button {
                // TODO: open side menu / profile
            } label: {
                Image(systemName: SFSymbols.menu.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: AppDimensions.iconSize, height: AppDimensions.iconSize)
                    .foregroundColor(HomeGridPalette.icon)
                    .frame(width: AppDimensions.iconLargeSize, height: AppDimensions.iconLargeSize)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.showMenuButton)

            Text(L10n.wishOn)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, AppPaddings.padding10)
                .foregroundColor(HomeGridPalette.title)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier(AccessibilityIdentifiers.wishListsLabel)

            Button {
                // TODO: show calendar with planned events
            } label: {
                IconView(viewState: viewModel.viewState.calendarIcon)
                    .frame(width: AppDimensions.iconLargeSize, height: AppDimensions.iconLargeSize)
                    .foregroundColor(HomeGridPalette.icon)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.showCalendarButton)
        }
    }

    private var tabBar: some View {
        HStack {
            Spacer(minLength: 0)
            HStack(spacing: AppPaddings.padding26) {
                tabButton(
                    title: L10n.homeTabWishlists,
                    tab: .wishlists,
                    accessibilityId: AccessibilityIdentifiers.homeWishlistsTab
                )
                tabButton(
                    title: L10n.toGive,
                    tab: .toGive,
                    accessibilityId: AccessibilityIdentifiers.showToGiveViewButton
                )
            }
            Spacer(minLength: 0)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(HomeGridPalette.subtitle.opacity(AppOpacityLevels.homeGridTabDivider))
                .frame(height: AppDimensions.homeGridTabDividerHeight)
        }
    }

    private func tabButton(title: String, tab: HomeTab, accessibilityId: String) -> some View {
        let isActive = selectedTab == tab
        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: AppPaddings.padding8) {
                Text(title)
                    .font(.body.weight(isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? HomeGridPalette.accent : HomeGridPalette.inactiveTab)
                Rectangle()
                    .fill(isActive ? HomeGridPalette.accent : Color.clear)
                    .frame(height: AppDimensions.homeGridTabUnderlineHeight)
                    .frame(maxWidth: .infinity)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityId)
    }

    private var homeGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppDimensions.wishListHomeGridSpacing) {
                ForEach(viewModel.viewState.wishLists) { wishList in
                    Button {
                        openWishList(wishList)
                    } label: {
                        WishListCardView(
                            viewState: WishListCardViewState(
                                imageName: wishList.image ?? "",
                                name: wishList.name,
                                subtitle: subtitle(for: wishList),
                                avatar: wishList.avatar
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppPaddings.padding16)
            .padding(.top, AppPaddings.padding16)
            .padding(.bottom, AppPaddings.padding26 + AppDimensions.fabSize)
        }
    }

    private var toGiveTabContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppDimensions.wishListHomeGridSpacing) {
                ForEach(0..<5, id: \.self) { _ in
                    NavigationLink(destination: ToGiveCardDetails()) {
                        WishListCardView(
                            viewState: WishListCardViewState(
                                imageName: SFSymbols.giftOutline.name,
                                name: L10n.nameHint,
                                subtitle: L10n.dateHint
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppPaddings.padding16)
            .padding(.top, AppPaddings.padding16)
            .padding(.bottom, AppPaddings.padding16)
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.toGiveLabel)
    }

    private var emptyState: some View {
        VStack(spacing: AppPaddings.padding8) {
            Spacer(minLength: 0)
            IconView(viewState: viewModel.viewState.emptyListIcon)
                .scaledToFit()
                .frame(width: AppDimensions.emptyListImageSize)
                .foregroundColor(HomeGridPalette.accent)
            Text(L10n.wishListEmptyView)
                .padding(.top, AppPaddings.padding8)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(HomeGridPalette.subtitle)
                .accessibilityIdentifier(AccessibilityIdentifiers.emptyWishList)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, AppPaddings.padding16)
    }

    private var fabShadow: AppShadowStyle {
        AppShadows.homeGridFAB(accent: HomeGridPalette.accent)
    }

    private var addWishlistFAB: some View {
        ZStack {
            NavigationLink(isActive: $isCreatingWishList) {
                if let newWishListViewModel {
                    NewWishlistView(viewModel: newWishListViewModel)
                }
            } label: {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)

            NavigationLink(isActive: $isShowingWishList) {
                if let openedWishListViewModel {
                    NewWishlistView(viewModel: openedWishListViewModel)
                }
            } label: {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)

            Button {
                openNewWishList()
            } label: {
                Image(systemName: SFSymbols.plus.name)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(HomeGridPalette.onAccent)
                    .frame(width: AppDimensions.fabSize, height: AppDimensions.fabSize)
                    .background(Circle().fill(HomeGridPalette.accent))
                    .shadow(
                        color: fabShadow.color,
                        radius: fabShadow.radius,
                        x: fabShadow.x,
                        y: fabShadow.y
                    )
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.addWishlistButton)
            .accessibilityLabel(L10n.addNewWishlist)
        }
    }

    private func openWishList(_ wishList: WishList) {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return
        }
        #endif
        openedWishListViewModel = AppAssembler.shared
            .resolver
            .resolve(NewWishListModule.self, argument: saveHandler())
            .makeViewModel(existing: wishList, isEditable: NewWishListViewModel.canEdit(wishList))
        isShowingWishList = true
    }

    private func openNewWishList() {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return
        }
        #endif
        newWishListViewModel = AppAssembler.shared
            .resolver
            .resolve(NewWishListModule.self, argument: saveHandler())
            .makeViewModel()
        isCreatingWishList = true
    }
    
    private func saveHandler() -> WishListSaveHandler {
        return { [viewModel] wishList, completion in
            viewModel.addNewWishList(wishList: wishList, completion: completion)
        }
    }

    private func subtitle(for wishList: WishList) -> String {
        if let eventDate = wishList.eventDate {
            return DateFormatter.shortDate.string(from: eventDate)
        }
        return L10n.wishesCountLabel(wishList.wishes.count)
    }
}

#Preview("With wishlists") {
    let stateMachine = WishListsStateMachine(
        calendarIcon: IconState(icon: SFSymbolsIcon(symbol: .calendar), isResizable: true),
        profileIcon: IconState(icon: SFSymbolsIcon(symbol: .person), isResizable: true),
        emptyListIcon: IconState(icon: SFSymbolsIcon(symbol: .heart), isResizable: true)
    )
    let stateFactory = WishListsStateFactory()
    let repository = FakeWishListRepository()
    let useCase = WishListsInteractor(repository: repository)
    let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)

    return WishListRootView(viewModel: viewModel)
}

#Preview("Empty") {
    let stateMachine = WishListsStateMachine(
        calendarIcon: IconState(icon: SFSymbolsIcon(symbol: .calendar), isResizable: true),
        profileIcon: IconState(icon: SFSymbolsIcon(symbol: .person), isResizable: true),
        emptyListIcon: IconState(icon: SFSymbolsIcon(symbol: .heart), isResizable: true)
    )
    let stateFactory = WishListsStateFactory()
    let repository = EmptyFakeWishListRepository()
    let useCase = WishListsInteractor(repository: repository)
    let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)

    return WishListRootView(viewModel: viewModel)
}
