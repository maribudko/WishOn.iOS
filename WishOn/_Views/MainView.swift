import SwiftUI

struct MainView: View {
    @State private var isAuthorized = false
    
    var wishLists: [WishList] = []
//    [WishList(name: "HP2Me", eventDate: Date(), gifts: []), WishList(name: "Christmas", eventDate: Date(), gifts: []), WishList(name: "General wishes", eventDate: Date(), gifts: [])]
    
    let columns: [GridItem] = {
        let width = UIScreen.main.bounds.width - 32
        let itemsPerRow = Int(width / 100)
        return Array(repeating: GridItem(.flexible()), count: itemsPerRow)
    }()
    
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
                        Text("Hello, Wisher!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                            .foregroundColor(
                                Color(Asset.primaryTitleColor.color)
                            )
                        
                        Text(
                            "Here you can provide some information about yourself, if you'd like to!"
                        )
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
                    }
                    
                    NavigationLink {
                        ToGiveView()
                    } label: {
                        Text("To Give")
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
                
                if !wishLists.isEmpty {
                    ScrollView{
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(wishLists) {wishlist in
                                NavigationLink(destination: WishListDetailsView()) {
                                    WishListCardView(wishList: wishlist)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                } else {
                    VStack{
                        Image(systemName: "heart.text.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundColor(Color(Asset.eucalyptus.color))
                        Text("Start your first WishList!\nAnd make your dreams come true!")
                        .padding(.top, 10)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(Asset.primaryColor.color))
                    }
                    .frame(maxHeight: .infinity)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .background(Color(Asset.backgroundColor.color).gradient)
            .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
