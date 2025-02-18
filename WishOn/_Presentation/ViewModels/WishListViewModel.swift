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
    var cancellable : AnyCancellable?
    
    
    func loadWishLists() {
        wishLists.removeAll()
        cancellable = repository.fetchWishLists()
            .sink(receiveCompletion: { completion in
                switch(completion){
                case .finished:
                    print("completion finished")
                    
                case .failure(let error):
                    print("Error occured: \(error)")
                }
            }, receiveValue: { list in
                self.wishLists.append(contentsOf: list)
            })
        
        
    }
    
    func addNewWishList(name: String, imageUrl: String, eventDate: Date, wishes: [Wish], isSelected: Bool, description: String, color: String) {
        
        let newWishList = WishList(name: name, image: imageUrl, eventDate: eventDate, wishes: wishes, isSelected: isSelected, description: description, color: color)
    
        repository.addWishList(newWishList)
            .sink { completion in
                switch completion {
                case .finished:
                    print("WishList added successfuly")
                case .failure(let error):
                    print("Error occured: \(error)")
                }
            } receiveValue: { _ in
                self.wishLists.append(newWishList)
            }
    }
    
    func removeWishList(id: String) {
        repository.deleteWishList(id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("WishList deleted successfuly")
                case .failure(let error):
                    print("Error occured: \(error)")
                }
            } receiveValue: { _ in
                self.wishLists.removeAll { $0.id.uuidString == id }
            }

    }
}
