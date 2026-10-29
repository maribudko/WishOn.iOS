import Testing
import WOResources
import WOCore
import Foundation
@testable import WOWishListsRootFeature

@Test func setWishLists() {
    let stateMachine = makeStateMachine()
    let wishList = WishList(
        id: UUID(),
        name: "New year",
        image: nil,
        eventDate: nil,
        wishes: [],
        description: "Presents from Saint Claus",
        createdAt: nil
    )
    
    stateMachine.setWishLists([wishList])
    
    let wishLists = stateMachine.state.wishLists
    
    #expect(wishLists.count == 1)
    #expect(wishLists.first?.name == "New year")
    #expect(wishLists.first?.description == "Presents from Saint Claus")
}

@Test func appendItems() {
    let stateMachine = makeStateMachine()
    
    #expect(stateMachine.state.wishLists.isEmpty)
    
    let newList = WishList(id: UUID(), name: "New", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    
    stateMachine.addWishList(newList)
    
    #expect(stateMachine.state.wishLists.count == 1)
    #expect(stateMachine.state.wishLists.first?.name == "New")
}

@Test func removeItems() {
    let idToRemove = UUID()
    let idToKeep = UUID()
    
    let stateMachine = makeStateMachine()
    let listToRemove = WishList(id: idToRemove, name: "To Remove", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    let listToKeep = WishList(id: idToKeep, name: "To Keep", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    
    stateMachine.setWishLists([listToKeep, listToRemove])
    stateMachine.removeWishList(by: idToRemove.uuidString)
    
    #expect(stateMachine.state.wishLists.count == 1)
    #expect(stateMachine.state.wishLists.first?.name == "To Keep")
}

@Test func emptyWishList() {
    let stateMachine = makeStateMachine()
    stateMachine.setWishLists([])
    #expect(stateMachine.state.wishLists.isEmpty)
}

@Test func removeNotExistingItem() {
    let stateMachine = makeStateMachine()
    let list = WishList(id: UUID(), name: "Keep", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    stateMachine.setWishLists([list])
    
    stateMachine.removeWishList(by: UUID().uuidString)
    #expect(stateMachine.state.wishLists.count == 1)
    #expect(stateMachine.state.wishLists.first?.name == "Keep")
}

@Test func replaceWishListUpdatesTheExistingOne() {
    let id = UUID()
    let list1 = WishList(id: id, name: "List 1", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    let list2 = WishList(id: id, name: "List 2", image: nil, eventDate: nil, wishes: [], description: "Updated", createdAt: nil)
    
    let stateMachine = makeStateMachine()
    stateMachine.setWishLists([list1])
    stateMachine.replaceWishList(list2)
    
    #expect(stateMachine.state.wishLists.count == 1)
    #expect(stateMachine.state.wishLists.first?.name == "List 2")
    #expect(stateMachine.state.wishLists.first?.description == "Updated")
}

@Test func duplicateWishList() {
    let id = UUID()
    let list1 = WishList(id: id, name: "List 1", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    let list2 = WishList(id: id, name: "List 2", image: nil, eventDate: nil, wishes: [], description: nil, createdAt: nil)
    
    let stateMachine = makeStateMachine()
    stateMachine.setWishLists([list1])
    stateMachine.addWishList(list2)
    
    #expect(stateMachine.state.wishLists.count == 1)
}

private func makeStateMachine() -> WishListsStateMachine {
    return .init(
        calendarIcon: .init(icon: SFSymbolsIcon(symbol: .calendar)),
        profileIcon: .init(icon: SFSymbolsIcon(symbol: .person)),
        emptyListIcon: .init(icon: SFSymbolsIcon(symbol: .heart)))
}
