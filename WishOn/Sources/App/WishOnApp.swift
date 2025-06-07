//
//  WishOnApp.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI
import FirebaseCore

// schema 
final class AppEnvironment {
    // shared
#if DEBUG
    //
#else
    //
#endif
    let key = "324234234234frwerwerwerrw"
    
}

@main
struct WishOnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isLoggedIn = false
    private let loginModule = LoginModule()
    
    let persistenceController = PersistenceController.shared
    
    init() {
        // CR: створити для unit tests окремий таргет +
        // CR: менеджер який буде повертати актуальне значення в якому ми режимі
        
        
#if DEBUG
        WishOnApp.unitTestConfig()
#else
        DIRepositoriesContainer.shared.register(repository: WishListRepository() as WishListRepositoryProtocol)
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                WishListsModule()
                    .view()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                LoginModule(onLoginSuccess: {
                    isLoggedIn = true
                })
                .view()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
