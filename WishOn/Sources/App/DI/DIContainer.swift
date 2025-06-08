//
//  DIContainer.swift
//  WishOn
//
//  Created by Mari Budko on 07.06.2025.
//

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        //Login dependencies
        container.register(LoginStateMachine.self) { _ in LoginStateMachine() }
        container.register(LoginStateFactory.self) { _ in LoginStateFactory() }
        
        container.register(WishListRepositoryProtocol.self) { _ in WishListRepository() }
        container.register(WishListsStateMachine.self) { _ in WishListsStateMachine() }
        container.register(WishListsStateFactory.self) { _ in WishListsStateFactory() }
        container.register(WishListRepository.self) { _ in WishListRepository()
        }
        container.register(WishListUseCase.self) { _ in
            WishListsInteractor(
                repository: self.container.resolve(WishListRepositoryProtocol.self)!
            )
        }
    }
}
