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

public struct WishListRootView: View {
    private var isAuthorized = false
    private var viewModel: WishListViewModel
    
    let columns = [
        GridItem(.adaptive(
            minimum: AppDimensions.wishListCardWidth,
            maximum: AppDimensions.wishListCardWidthMax)
        )
    ]
    
    public init(isAuthorized: Bool = false, viewModel: WishListViewModel) {
        self.isAuthorized = isAuthorized
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        //TODO: show calendar with planed events
                    } label: {
                        IconView(viewState: viewModel.viewState.calendarIcon)
                            .frame(width: AppDimensions.iconLargeSize,
                                   height: AppDimensions.iconLargeSize)
                            .foregroundColor(
                                Color(Asset.primaryTextColor.color)
                            )
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.showCalendarButton)
                    
                    Text(L10n.wishOn)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color(Asset.primaryTitleColor.color))
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        // TODO: open user profile
                    } label: {
                        ZStack {
                            IconView(viewState: viewModel.viewState.profileIcon)
                                .frame(width: AppDimensions.iconLargeSize, height: AppDimensions.iconLargeSize, alignment: .trailing)
                                .foregroundColor(
                                    Color(Asset.primaryTextColor.color)
                                )
                            
                            if !isAuthorized {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: AppDimensions.tinyIConSize, height: AppDimensions.tinyIConSize)
                                    .offset(x: AppDimensions.indicatorOffset, y: -AppDimensions.indicatorOffset)
                            }
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.showProfileButton)
                }
                
                HStack(alignment: .top) {
                    UserImageView(viewState: viewModel.userImageViewState)
                    
                    VStack(alignment: .leading) {
                        Text(L10n.helloWisher)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .foregroundColor(
                                Color(Asset.primaryTitleColor.color)
                            )
                        
                        Text(L10n.aboutWisherPromt)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(Asset.primaryTextColor.color))
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    NavigationLink {
                        
                        //MARK: MENTOR: чи нормально так вирішувати проблему з відсутністю залежностей під час прев'ю для Canvas Preview?
                        #if DEBUG
                        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                            EmptyView()
                        } else {
                            AppAssembler.shared
                                .resolver
                                .resolve(NewWishListModule.self)
                                .view()
                        }
                        #else
                        AppAssembler.shared
                            .resolver
                            .resolve(NewWishListModule.self)
                            .view()
                        #endif
                    } label: {
                        Text(L10n.addNewWishlist)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color(Asset.primaryColor.color)))
                            .foregroundColor(.white)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.addWishlistButton)
                    
                    NavigationLink {
                        ToGiveView()
                    } label: {
                        Text(L10n.toGive)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(Color(Asset.secondaryColor.color))
                            )
                            .foregroundColor(.black)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.showToGiveViewButton)
                }
                .padding(.top)
                
                if !viewModel.viewState.wishLists.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: AppPaddings.padding8) {
                            ForEach(viewModel.viewState.wishLists) { wishList in
                                
                                let cardViewState = WishListCardViewState(
                                    imageName: wishList.image ?? "",
                                    name: wishList.name,
                                    formattedDate: DateFormatter.shortDate.string(from: wishList.eventDate ?? Date())
                                )
                                NavigationLink(destination: WishListDetailsView()) {
                                    WishListCardView(viewState: cardViewState)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack {
                        IconView(viewState: viewModel.viewState.emptyListIcon)
                            .scaledToFit()
                            .frame(width: AppDimensions.emptyListImageSize)
                            .foregroundColor(Color(Asset.eucalyptus.color))
                        Text(L10n.wishListEmptyView)
                            .padding(.top, AppPaddings.padding8)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(Asset.primaryColor.color))
                            .accessibilityIdentifier(AccessibilityIdentifiers.emptyWishList)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, AppPaddings.padding16)
            .background(Color(Asset.backgroundColor.color).gradient)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadWishLists()
            }
            .environmentObject(viewModel)
        }
    }
}

#Preview {
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
