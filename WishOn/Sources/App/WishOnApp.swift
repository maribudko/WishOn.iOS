//
//  WishOnApp.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import DependencyInjection
import WOWishListsRootFeature
import WOLoginFeature
import WONewWishListFeature
import WOAddNewItemFeature
import WOCore

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
    @StateObject var session = CurrentUserManager.shared
    
    init() {
        registerAssemblies()
        // CR: створити для unit tests окремий таргет +
        // CR: менеджер який буде повертати актуальне значення в якому ми режимі
    }
    
    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                AppAssembler.shared
                    .resolver
                    .resolve(WishListsModule.self)
                    .view()
            } else {
                AppAssembler.shared
                    .resolver
                    .resolve(LoginModule.self, argument: {
                        //isLoggedIn = true
                    })
                    .view()
            }
        }
    }
    
    func registerAssemblies() {
        AppAssembler.shared.addAssemblies(assemblies:         [
            LoginAssembly(),
            WishListsAssembly(),
            AddNewItemAssembly(),
            NewWishListAssembly(),
            IconAssembly(),
        ])
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
    }
}
