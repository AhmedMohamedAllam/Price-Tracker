//
//  PriceTrackerTests.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam on 25/11/2025.
//

import XCTest
@testable import PriceTracker

// MARK: - Model Tests

@MainActor
final class StockSymbolTests: XCTestCase {
    
    func test_changeIndicator_returnsUp_whenPriceIncreased() {
        let symbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple",
            currentPrice: 150.0,
            previousPrice: 140.0
        )
        
        XCTAssertEqual(symbol.changeIndicator, .up)
    }
    
    func test_changeIndicator_returnsDown_whenPriceDecreased() {
        let symbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple",
            currentPrice: 130.0,
            previousPrice: 140.0
        )
        
        XCTAssertEqual(symbol.changeIndicator, .down)
    }
    
    func test_changeIndicator_returnsNone_whenPriceUnchanged() {
        let symbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple",
            currentPrice: 140.0,
            previousPrice: 140.0
        )
        
        XCTAssertEqual(symbol.changeIndicator, .none)
    }
    
    func test_changeIndicator_returnsNone_whenNoPreviousPrice() {
        let symbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple",
            currentPrice: 140.0,
            previousPrice: nil
        )
        
        XCTAssertEqual(symbol.changeIndicator, .none)
    }
    
    func test_comparable_sortsLowerPriceFirst() {
        let lower = StockSymbol(symbol: "A", description: "", currentPrice: 100.0, previousPrice: nil)
        let higher = StockSymbol(symbol: "B", description: "", currentPrice: 200.0, previousPrice: nil)
        
        XCTAssertTrue(lower < higher)
    }
    
    func test_id_returnsSymbol() {
        let symbol = StockSymbol(symbol: "AAPL", description: "Apple", currentPrice: 100.0, previousPrice: nil)
        
        XCTAssertEqual(symbol.id, "AAPL")
    }
}
