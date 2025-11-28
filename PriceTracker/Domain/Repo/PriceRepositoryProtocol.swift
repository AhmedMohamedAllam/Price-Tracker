//
//  PriceRepositoryProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

// MARK: - Repository Errors

enum PriceRepositoryError: Error, Equatable {
    case encodingFailed
    case decodingFailed
    case connectionLost
    
    var localizedDescription: String {
        switch self {
        case .encodingFailed:
            return "Failed to encode price update"
        case .decodingFailed:
            return "Failed to decode received message"
        case .connectionLost:
            return "WebSocket connection lost"
        }
    }
}

// MARK: - Repository Protocol

protocol PriceRepositoryProtocol {
    var priceUpdates: AnyPublisher<PriceUpdate, Never> { get }
    var connectionStatus: AnyPublisher<Bool, Never> { get }
    var errors: AnyPublisher<PriceRepositoryError, Never> { get }
    func fetchSymbols() -> [StockSymbol]
    func connect()
    func disconnect()
}
