//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 31.07.2025.
//

import Foundation
import FirebaseAuth

public final class CurrentUserManager: ObservableObject {
    public static let shared = CurrentUserManager()
    
    @Published public private(set) var currentUser: User?
    @Published public private(set) var isLoggedIn: Bool = false
    @Published public private(set) var userName: String?
    @Published public private(set) var userEmail: String?
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    private init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            self?.isLoggedIn = user != nil
            self?.userName = user?.displayName
            self?.userEmail = user?.email
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    public func logout(completion: ((Error?) -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            completion?(nil)
        } catch let signOutError {
            completion?(signOutError)
        }
    }
}
