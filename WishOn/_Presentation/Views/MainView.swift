import SwiftUI

struct MainView: View {
    //@EnvironmentObject var wishListVM: WishListViewModel
    //@ObservedObject var repository: WishListRepository = WishListRepository()
    @State private var isAuthorized = false
    @StateObject var viewModel = WishListViewModel()
   // @State private var wishLists:[WishList] = []
    
//    let columns: [GridItem] = {
//        let width = UIScreen.main.bounds.width - 32
//        let itemsPerRow = Int(width / Constants.wishListCardWidth)
//        return Array(repeating: GridItem(.flexible()), count: itemsPerRow)
//    }()
    
    let columns = [
        GridItem(.adaptive(minimum: Constants.wishListCardWidth, maximum: Constants.wishListCardWidth+20)),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button {
                        //show calendar with planed events
                    } label: {
                        Image(systemName: "calendar.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
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
                        //open user profile
                    } label: {
                        ZStack{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .trailing)
                                .foregroundColor(
                                    Color(Asset.primaryTextColor.color)
                                )
                            
                            if !isAuthorized {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.showProfileButton)
                }
                
                HStack(alignment: .top){
                    Image(systemName: "gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(Asset.backgroundColor.color))
                        .padding(26)
                        .background(
                            Circle().fill(Color(Asset.primaryColor.color))
                        )
                        .clipShape(.circle)
                    
                    VStack(alignment: .leading){
                        Text(L10n.helloWisher)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .foregroundColor(
                                Color(Asset.primaryTitleColor.color)
                            )
                        
                        Text(L10n.aboutWisherPromt)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 0)
                        .foregroundColor(Color(Asset.primaryTextColor.color))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    
                }
                .frame(maxWidth: .infinity)
                

                HStack {
                    NavigationLink {
                        AddWishlistView()
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
                
                if !viewModel.wishLists.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.wishLists) { wishList in
                                NavigationLink(destination: WishListDetailsView()) {
                                    WishListCardView(wishList: wishList)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack{
                        Image(systemName: "heart.text.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundColor(Color(Asset.eucalyptus.color))
                        Text(L10n.wishListEmptyView)
                        .padding(.top, 10)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(Asset.primaryColor.color))
                        .accessibilityIdentifier(AccessibilityIdentifiers.emptyWishList)
                    }
                    .frame(maxHeight: .infinity)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .background(Color(Asset.backgroundColor.color).gradient)
            .navigationBarHidden(true)
            .onAppear{
                viewModel.loadWishLists()
            }
            .onReceive(viewModel.$wishLists) { wishLists in
                print("WishList count: \(wishLists.count)")
                for wishList in wishLists {
                    print("id: \(String(describing: wishList.id)), name: \(wishList.name)")
                }
            }
            .environmentObject(viewModel)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(WishListViewModel())
    }
}
