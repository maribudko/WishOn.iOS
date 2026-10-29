//
//  IconAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 17.06.2025.
//

import Swinject
import WOResources

public final class IconAssembly: Assembly {
    public init() {}
    public func assemble(container: Swinject.Container) {
        container.register(IconRepresentable.self, name: IconNames.closeIcon) { _ in SFSymbolsIcon(symbol: .close) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.backIcon) { _ in SFSymbolsIcon(symbol: .back) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.arrowDownIcon) { _ in SFSymbolsIcon(symbol: .arrowDown) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.checkmarkIcon) { _ in SFSymbolsIcon(symbol: .checkmark) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.downIcon) { _ in SFSymbolsIcon(symbol: .down) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.plusCircleIcon) { _ in SFSymbolsIcon(symbol: .plusCircle) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.calendarIcon) { _ in SFSymbolsIcon(symbol: .calendar) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.profileIcon) { _ in SFSymbolsIcon(symbol: .person) }
            .inObjectScope(.container)
        container.register(IconRepresentable.self, name: IconNames.heartListIcon) { _ in SFSymbolsIcon(symbol: .heart) }
            .inObjectScope(.container)
    }
}
