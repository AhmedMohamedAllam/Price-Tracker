//
//  UsecaseProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation

public protocol UsecaseProtocol {
    associatedtype Model

    @discardableResult
    func execute() -> Model
}
