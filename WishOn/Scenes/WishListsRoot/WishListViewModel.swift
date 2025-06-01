//
//  WishListViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation
import Combine
import Firebase

class WishListViewModel: ObservableObject {
    @Published private(set) var viewState: WishListsState
    
    private let stateMachine: WishListsStateMachine
    private let stateFactory: WishListsStateFactory
    private let useCase: WishListUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(stateMachine: WishListsStateMachine, stateFactory: WishListsStateFactory, useCase: WishListUseCase) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.useCase = useCase
        self.viewState = stateFactory.make(from: stateMachine.state)
    }
    
    func loadWishLists() {
        useCase.fetchWishLists()
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Load error: \(error)")
                }
            } receiveValue: { [weak self] wishLists in
                self?.stateMachine.setWishLists(wishLists)
                self?.updateViewState()
            }
            .store(in: &cancellables)
    }
   
    
    func addNewWishList(wishList: WishList) {
        useCase.addWishList(wishList)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Load error: \(error)")
                }
            } receiveValue: { _ in
                self.stateMachine.addWishList(wishList)
                self.updateViewState()
            }
            .store(in: &cancellables)

    }
    
    func removeWishList(id: String) {
        useCase.deleteWishList(id)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Load error: \(error)")
                }
            } receiveValue: { _ in
                self.stateMachine.removeWishList(by: id)
                self.updateViewState()
            }
            .store(in: &cancellables)

    }
    
    private func updateViewState() {
        viewState = stateFactory.make(from: stateMachine.state)
    }
}
