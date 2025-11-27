//
//  PriceRepositoryProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

protocol PriceRepositoryProtocol {
    var priceUpdates: AnyPublisher<PriceUpdate, Never> { get }
    var connectionStatus: AnyPublisher<Bool, Never> { get }
    func fetchSymbols() -> [StockSymbol]
    func connect()
    func disconnect()
}
