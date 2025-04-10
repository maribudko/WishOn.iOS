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
    private var cancellables = Set<AnyCancellable>()
    @Published var repository: WishListRepositoryProtocol = DIRepositoriesContainer.shared.resolve()
    @Published var wishLists: [WishList] = []
    var cancellable: AnyCancellable?
    
    func loadWishLists() {
        wishLists.removeAll()
        cancellable = repository.fetchWishLists()
            .sink(receiveCompletion: { completion in    
                switch completion {
                case .finished:
                    debugPrint("completion finished")
                    
                case .failure(let error):
                    debugPrint("Error occured: \(error)")
                }
            }, receiveValue: { list in
                self.wishLists.append(contentsOf: list)
            })
    }
    
    func addNewWishList(
        wishList: WishList
    ) {
        repository.addWishList(wishList)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("WishList added successfuly")
                case .failure(let error):
                    debugPrint("Error occured: \(error)")
                }
            } receiveValue: { _ in
                self.wishLists.append(wishList)
            }
    }
    
    func removeWishList(id: String) {
        repository.deleteWishList(id)
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("WishList deleted successfuly")
                case .failure(let error):
                    debugPrint("Error occured: \(error)")
                }
            } receiveValue: { _ in
                self.wishLists.removeAll { $0.id.uuidString == id }
            }
    }
}
