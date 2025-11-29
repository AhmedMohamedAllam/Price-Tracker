//
//  MockFetchSymbolsUseCase.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam.
//

import Foundation
@testable import PriceTracker

final class MockFetchSymbolsUseCase: FetchSymbolsUseCaseProtocol {
    
    // MARK: - Configurable Data
    
    var symbolsToReturn: [StockSymbol] = []
    
    // MARK: - Call Tracking
    
    private(set) var executeCallCount = 0
    
    // MARK: - Protocol Methods
    
    func execute() -> [StockSymbol] {
        executeCallCount += 1
        return symbolsToReturn
    }
}

