import Foundation
import Testing
@testable import WOCore

@Test func encodedWishlistRoundTripsNameDateAndWishes() throws {
    let id = UUID()
    let eventDate = Date(timeIntervalSince1970: 1_800_000_000)
    let createdAt = Date(timeIntervalSince1970: 1_700_000_000)
    let wish = Wish(
        id: UUID(),
        name: "Mug",
        image: "https://shop.example/mug.jpg",
        price: 499.5,
        currency: "UAH",
        link: "https://shop.example/mug",
        isTaken: false
    )
    let wishList = WishList(
        id: id,
        name: "Birthday",
        image: nil,
        avatar: "avatar-field",
        eventDate: eventDate,
        wishes: [wish],
        description: "Gifts",
        createdAt: createdAt,
        ownerUid: "client-supplied"
    )
    
    let data = try WishListFirestoreMapping.encode(wishList, ownerUid: "signed-in-user")
    let decoded = WishListFirestoreMapping.decode(data, documentID: id.uuidString)
    
    #expect(data["ownerUid"] as? String == "signed-in-user")
    #expect(data["avatar"] as? String == "avatar-field")
    #expect(decoded?.id == id)
    #expect(decoded?.name == "Birthday")
    #expect(decoded?.description == "Gifts")
    #expect(decoded?.image == nil)
    #expect(decoded?.avatar == "avatar-field")
    #expect(decoded?.ownerUid == "signed-in-user")
    #expect(decoded?.wishes.count == 1)
    #expect(decoded?.wishes.first?.name == "Mug")
    #expect(decoded?.wishes.first?.price == 499.5)
    #expect(decoded?.wishes.first?.currency == "UAH")
    #expect(decoded?.wishes.first?.link == "https://shop.example/mug")
    #expect(decoded?.wishes.first?.image == "https://shop.example/mug.jpg")
    #expect(decoded?.wishes.first?.isTaken == false)
    #expect(datesMatch(decoded?.eventDate, eventDate))
    #expect(datesMatch(decoded?.createdAt, createdAt))
}

@Test func partialDocumentKeepsNameAndDropsMissingWishes() {
    let id = UUID()
    let decoded = WishListFirestoreMapping.decode(
        [
            "name": "Old list",
            "description": "Note",
            "ownerUid": "signed-in-user"
        ],
        documentID: id.uuidString
    )
    
    #expect(decoded?.id == id)
    #expect(decoded?.name == "Old list")
    #expect(decoded?.description == "Note")
    #expect(decoded?.wishes.isEmpty == true)
    #expect(decoded?.eventDate == nil)
    #expect(decoded?.avatar == nil)
}

private func datesMatch(_ lhs: Date?, _ rhs: Date) -> Bool {
    guard let lhs else { return false }
    return abs(lhs.timeIntervalSince(rhs)) < 1
}
