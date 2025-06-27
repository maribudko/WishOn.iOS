//
//  BaseModule.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

public protocol BaseSwiftUIModule {
    
    associatedtype ContentView: View
    func view() -> ContentView
}
