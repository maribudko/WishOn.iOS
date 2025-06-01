//
//  DIContainer.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation

class DIRepositoriesContainer {
    static let shared = DIRepositoriesContainer()
    
    private lazy var repositories = [String: Any]()
    
    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    func register<T>(repository: T) {
        repositories[typeName(type(of: T.self))] = repository
    }
    
    func resolve<T>() -> T {
        let key = typeName(type(of: T.self))
        return repositories[key] as! T
    }
}
