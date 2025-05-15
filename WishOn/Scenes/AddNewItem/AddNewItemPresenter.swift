//
//  AddNewItemPresenter.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import Foundation

protocol AddNewItemPresenterProtocol {
    func perform(with action: AddNewItemPresenter.Action)
}

final class AddNewItemPresenter: AddNewItemPresenterProtocol {
    func perform(with action: Action) {
        //TODO: do perform
    }
    
    enum Action {
        case onLoad
        case didChangeName(String)
        case didChangeLink(String)
        case didChangePrice(String)
        case didTapAddButton
    }
}
