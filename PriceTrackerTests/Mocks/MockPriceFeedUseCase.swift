//
//  MockPriceFeedUseCase.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam.
//

import Foundation
import Combine
@testable import PriceTracker

final class MockPriceFeedUseCase: PriceFeedUseCaseProtocol {
    
    // MARK: - Controllable Publishers
    
    private let priceUpdatesSubject = PassthroughSubject<PriceUpdate, Never>()
    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(false)
    
    var stream: AnyPublisher<Bool, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }
    
    var priceUpdates: AnyPublisher<PriceUpdate, Never> {
        priceUpdatesSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Call Tracking
    
    private(set) var startCallCount = 0
    private(set) var stopCallCount = 0
    
    // MARK: - Protocol Methods
    
    func start() {
        startCallCount += 1
    }
    
    func stop() {
        stopCallCount += 1
    }
    
    // MARK: - Test Helpers
    
    func simulatePriceUpdate(_ update: PriceUpdate) {
        priceUpdatesSubject.send(update)
    }
    
    func simulateConnectionStatus(_ isConnected: Bool) {
        connectionStatusSubject.send(isConnected)
    }
}

