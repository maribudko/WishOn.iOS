//
//  PreviewHostApp.swift
//  PreviewHost
//
//  Created by Mari Budko on 18.07.2025.
//

import SwiftUI
import DependencyInjection
import WOLoginFeature
import WOWishListsRootFeature
import WOCore
import WOAddNewItemFeature
import WONewWishListFeature
import FirebaseCore

@main
struct PreviewHostApp: App {
    
    init() {
        AppAssembler.shared.addAssemblies(assemblies: [
            LoginAssembly(),
            WishListsAssembly(),
            AddNewItemAssembly(),
            NewWishListAssembly(),
            IconAssembly(),
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            let screen = UITestHelper.screenFromLunchArguments()
            PreviewHost(screen: screen)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
