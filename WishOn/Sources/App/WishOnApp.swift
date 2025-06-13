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
    
    init() {
        // CR: створити для unit tests окремий таргет +
        // CR: менеджер який буде повертати актуальне значення в якому ми режимі
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                AppAssembler.shared
                    .resolver
                    .resolve(WishListsModule.self)
                    .view()
            } else {
                AppAssembler.shared
                    .resolver
                    .resolve(LoginModule.self, argument: {
                        isLoggedIn = true
                    })
                    .view()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
