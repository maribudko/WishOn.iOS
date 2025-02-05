//
//  WishOnApp.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI


@main
struct WishOnApp: App {
    
    @StateObject private var wishListVM: WishListViewModel
    
    let persistenceController = PersistenceController.shared
    //#if DEBUG
    //    let diContainer = DIContainer(wishListRepository: MockWishListRepository())
    //    #else
    //    let diContainer = DIContainer(wishListRepository: FirestoreWishListRepository())
    //#endif

    
    init() {
//        let mockRepository = MockWishListRepository()
//
//        let shouldReturnEmpty = CommandLine.arguments.contains("--emptyList")
//        mockRepository.shouldReturnEmptyList = shouldReturnEmpty
    #if DEBUG
            WishOnApp.unitTestConfig()
    #else
            DIRepositoriesContainer.shared.register(repository: FirestoreWishListRepository() as WishListRepositoryProtocol)
    #endif
        
        _wishListVM = StateObject(
            wrappedValue: WishListViewModel()
        )
            
    }
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(wishListVM)
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
        }
    }
    
    
#if DEBUG
    static func unitTestConfig() {
        if CommandLine.arguments.contains(UnitTestsCaseConstants.emptyList) {
            DIRepositoriesContainer.shared.register(repository: MockWishListEmptyRepository() as WishListRepositoryProtocol)
        } else {
            DIRepositoriesContainer.shared.register(repository: MockWishListRepository() as WishListRepositoryProtocol)
        }
    }
#endif

}
