import SwiftUI

struct WishListsState {
    let addNewWishlistButton: NavigationLinkButtonViewState
    let toGiveButton: NavigationLinkButtonViewState
    let wishLists: [WishList]
}

struct WishListRootView: View {
    private var isAuthorized = false
    private var viewModel: WishListViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: AppDimensions.wishListCardWidth, maximum: AppDimensions.wishListCardWidthMax))
    ]
    
    init(isAuthorized: Bool = false, viewModel: WishListViewModel) {
        self.isAuthorized = isAuthorized
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        //TODO: show calendar with planed events
                    } label: {
                        Image(systemName: "calendar.circle")
                            .resizable()
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
                            Image(systemName: "person.circle")
                                .resizable()
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
                    Image(systemName: "gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: AppDimensions.userImageSize,
                               height: AppDimensions.userImageSize)
                        .foregroundColor(Color(Asset.backgroundColor.color))
                        .padding(AppPaddings.padding26)
                        .background(
                            Circle().fill(Color(Asset.primaryColor.color))
                        )
                        .clipShape(.circle)
                    
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
                        AddWishlistView(viewModel: viewModel)
                    } label: {
                        Text(L10n.addNewWishlist)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(Color(Asset.primaryColor.color)))
                            .foregroundColor(.white)
                            .accessibilityIdentifier(AccessibilityIdentifiers.addWishlistButton)
                    }
                    
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
                }
                .padding(.top)
                .accessibilityIdentifier(AccessibilityIdentifiers.showToGiveViewButton)
                
                if !viewModel.viewState.wishLists.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: AppPaddings.padding8) {
                            ForEach(viewModel.viewState.wishLists) { wishList in
                                
                                let cardViewState = WishListCardViewState(
                                    imageName: wishList.image ?? "",
                                        name: wishList.name,
                                    date: wishList.eventDate ?? Date()
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
                        Image(systemName: "heart.text.square")
                            .resizable()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let stateMachine = WishListsStateMachine()
        let stateFactory = WishListsStateFactory()
        let repository = WishListRepository()
        let useCase = WishListsInteractor(repository: repository)
        let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)
        
        WishListRootView(viewModel: viewModel)
    }
}
