//
//  FakeWishListRepository.swift
//  WOCore
//
//  Created by Mari Budko on 18.07.2025.
//
import Foundation
import Combine

public final class FakeWishListRepository: WishListRepositoryProtocol {

    public init() {}

    public func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        let calendar = Calendar.current
        let birthday = Wish(
            id: UUID(),
            name: "Headphones",
            image: "",
            price: 199,
            currency: "USD",
            link: "",
            isTaken: false
        )
        let testData = [
            WishList(
                id: UUID(),
                name: "Birthday",
                image: "gift",
                eventDate: calendar.date(byAdding: .day, value: 14, to: Date()),
                wishes: [birthday],
                description: "Birthday gifts",
                createdAt: Date()
            ),
            WishList(
                id: UUID(),
                name: "New Year",
                image: "sparkles",
                eventDate: calendar.date(byAdding: .month, value: 2, to: Date()),
                wishes: [],
                description: "New Year gifts",
                createdAt: Date()
            ),
            WishList(
                id: UUID(),
                name: "Housewarming",
                image: "house",
                eventDate: calendar.date(byAdding: .month, value: 1, to: Date()),
                wishes: [],
                description: "New home",
                createdAt: Date()
            ),
            WishList(
                id: UUID(),
                name: "Just because",
                image: nil,
                eventDate: nil,
                wishes: [
                    Wish(id: UUID(), name: "Book", image: "", price: 20, currency: "USD", link: "", isTaken: false),
                    Wish(id: UUID(), name: "Candle", image: "", price: 15, currency: "USD", link: "", isTaken: false)
                ],
                description: "No date yet",
                createdAt: Date()
            )
        ]

        return Just(testData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

/// Preview / empty-state helper that returns no lists.
public final class EmptyFakeWishListRepository: WishListRepositoryProtocol {
    public init() {}

    public func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
