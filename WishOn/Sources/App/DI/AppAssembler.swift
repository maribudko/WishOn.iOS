//
//  AppAssembler.swift
//  WishOn
//
//  Created by Mari Budko on 11.06.2025.
//

import Swinject

final class AppAssembler {
    static let shared = AppAssembler()
    
    private let assembler: Assembler
    public let resolver: DIResolver
    
    private init() {
        assembler = Assembler([
            LoginAssembly(),
            WishListsAssembly(),
            AddNewItemAssembly(),
            NewWishListAssembly(),
        ])
        resolver = SwinjectResolver(resolver: assembler.resolver)
    }
}
