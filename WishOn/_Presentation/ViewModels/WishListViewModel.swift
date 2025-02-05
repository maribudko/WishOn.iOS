//
//  WishListViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation


class WishListViewModel: ObservableObject {
    @Published var wishLists: [WishList] = []
    
    func loadWishLists() async {
        guard var repository: WishListRepositoryProtocol = DIRepositoriesContainer.shared.resolve() else {
            return
        }
        do{
            let lists = try await repository.fetchWishList()
            self.wishLists = lists
        } catch {
            print("Failed to load data")
        }
    }
}
