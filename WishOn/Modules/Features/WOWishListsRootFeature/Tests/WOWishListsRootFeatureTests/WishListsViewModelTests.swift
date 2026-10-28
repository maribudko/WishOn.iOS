//
//  File.swift
//  WOWishListsRootFeature
//
//  Created by Mari Budko on 18.07.2025.
//

import Foundation
import Testing
import Combine
import WOCore
import WOResources
@testable import WOWishListsRootFeature

@Test func viewModelFetchWishLists() async throws {
    let viewModel = makeViewModel()
    
    #expect(viewModel.viewState.wishLists.isEmpty)
    
    viewModel.onAppear()
    
    try await Task.sleep(nanoseconds: 100_000_000)
    
    let wishLists = viewModel.viewState.wishLists
    #expect(wishLists.count == 4)
    #expect(wishLists[0].name == "Birthday")
    #expect(wishLists[1].name == "New Year")
    #expect(wishLists.map(\.name).contains("Housewarming"))
}

@Test func viewModelAddWishList() async throws {
    let viewModel = makeViewModel()
    viewModel.onAppear()
    try await Task.sleep(nanoseconds: 100_000_000)
    
    let newList = WishList(
        id: UUID(),
        name: "Party",
        image: nil,
        eventDate: nil,
        wishes: [],
        description: nil,
        createdAt: nil
    )
    
    viewModel.addNewWishList(wishList: newList)
    try await Task.sleep(nanoseconds: 100_000_000)
    let titles = viewModel.viewState.wishLists.map(\.self.name)
    #expect(titles.contains("Party"))
}

@Test func viewModelRemoveWishList() async throws{
    let viewModel = makeViewModel()
    viewModel.onAppear()
    try await Task.sleep(nanoseconds: 100_000_000)
    
    let idToRemove = viewModel.viewState.wishLists.first?.id
    #expect(idToRemove != nil)
    
    viewModel.removeWishList(id: idToRemove!.uuidString)
    try await Task.sleep(nanoseconds: 100_000_000)
    
    let titles = viewModel.viewState.wishLists.map(\.self.name)
    #expect(!titles.contains("Birthday"))
}

@Test func viewModelViewStateInitial() {
    let viewModel = makeViewModel()
    #expect(viewModel.userImageViewState.image == nil)
    
    if let icon = viewModel.userImageViewState.placeholderIcon as? SFSymbolsIcon {
        #expect(icon.symbol == .gift)
    } else {
        #expect(Bool(false), "Expected placeholderIcon to be SFSymbolsIcon.")
    }
}

private func makeViewModel() -> WishListViewModel {
    let stateMachine = WishListsStateMachine(
        calendarIcon: .init(icon: SFSymbolsIcon(symbol: .calendar)),
        profileIcon: .init(icon: SFSymbolsIcon(symbol: .person)),
        emptyListIcon: .init(icon: SFSymbolsIcon(symbol: .heart))
    )
    let stateFactory = WishListsStateFactory()
    let repository = FakeWishListRepository()
    let useCase = WishListsInteractor(repository: repository)
    
    return WishListViewModel(
        stateMachine: stateMachine,
        stateFactory: stateFactory,
        useCase: useCase
    )
}
