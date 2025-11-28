//
//  MockPriceRepository.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam.
//

import Foundation
import Combine
@testable import PriceTracker

final class MockPriceRepository: PriceRepositoryProtocol {
    // MARK: - Controllable Publishers
    
    private let priceUpdatesSubject = PassthroughSubject<PriceUpdate, Never>()
    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorsSubject = PassthroughSubject<PriceRepositoryError, Never>()
    
    var priceUpdates: AnyPublisher<PriceUpdate, Never> {
        priceUpdatesSubject.eraseToAnyPublisher()
    }
    
    var connectionStatus: AnyPublisher<Bool, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
    
    var errors: AnyPublisher<PriceRepositoryError, Never> {
        errorsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Configurable Data
    
    var symbolsToReturn: [StockSymbol] = []
    
    // MARK: - Call Tracking
    
    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    
    // MARK: - Protocol Methods
    
    func fetchSymbols() -> [StockSymbol] {
        symbolsToReturn
    }
    
    func connect() {
        connectCallCount += 1
    }
    
    func disconnect() {
        disconnectCallCount += 1
    }
    
    // MARK: - Test Helpers
    
    func simulatePriceUpdate(_ update: PriceUpdate) {
        priceUpdatesSubject.send(update)
    }
    
    func simulateConnectionStatus(_ isConnected: Bool) {
        connectionStatusSubject.send(isConnected)
    }
    
    func simulateError(_ error: PriceRepositoryError) {
        errorsSubject.send(error)
    }
}
