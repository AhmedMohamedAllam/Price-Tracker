//
//  SymbolDetailViewModelTests.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam.
//

import XCTest
import Combine
@testable import PriceTracker

@MainActor
final class SymbolDetailViewModelTests: XCTestCase {
    
    private var mockRepository: MockPriceRepository!
    private var priceFeedUseCase: PriceFeedUseCase!
    private var sut: SymbolDetailViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPriceRepository()
        priceFeedUseCase = PriceFeedUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        priceFeedUseCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func makeSymbol(_ symbol: String, price: Double, previousPrice: Double? = nil) -> StockSymbol {
        StockSymbol(
            symbol: symbol,
            description: "Test \(symbol)",
            currentPrice: price,
            previousPrice: previousPrice
        )
    }
    
    private func createSUT(with symbol: StockSymbol) {
        sut = SymbolDetailViewModel(
            initialSymbol: symbol,
            priceFeedUseCase: priceFeedUseCase
        )
    }
    
    // MARK: - Initial State Tests
    
    func test_init_setsInitialSymbol() {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        
        // When
        createSUT(with: initialSymbol)
        
        // Then
        XCTAssertEqual(sut.symbol.symbol, "AAPL")
        XCTAssertEqual(sut.symbol.currentPrice, 150.0)
        XCTAssertEqual(sut.symbol.description, "Test AAPL")
    }
    
    func test_init_preservesPreviousPrice() {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0, previousPrice: 140.0)
        
        // When
        createSUT(with: initialSymbol)
        
        // Then
        XCTAssertEqual(sut.symbol.previousPrice, 140.0)
    }
    
    // MARK: - Price Update Tests
    
    func test_priceUpdate_updatesSymbolWhenMatching() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Price updated")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.currentPrice == 200.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.currentPrice, 200.0)
    }
    
    func test_priceUpdate_setsPreviousPriceCorrectly() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Previous price set")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.previousPrice == 150.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.previousPrice, 150.0)
    }
    
    func test_priceUpdate_ignoresNonMatchingSymbol() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        // When - send update for different symbol
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "GOOG", price: 500.0))
        
        // Give some time for any potential update
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - AAPL price should remain unchanged
        XCTAssertEqual(sut.symbol.symbol, "AAPL")
        XCTAssertEqual(sut.symbol.currentPrice, 150.0)
    }
    
    func test_priceUpdate_preservesDescription() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Price updated")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.currentPrice == 200.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.description, "Test AAPL")
    }
    
    func test_priceUpdate_preservesSymbolIdentifier() async {
        // Given
        let initialSymbol = makeSymbol("TSLA", price: 250.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Price updated")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.currentPrice == 300.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "TSLA", price: 300.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.symbol, "TSLA")
        XCTAssertEqual(sut.symbol.id, "TSLA")
    }
    
    // MARK: - Change Indicator Tests
    
    func test_changeIndicator_showsUpWhenPriceIncreases() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Price increased")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.currentPrice == 200.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.changeIndicator, .up)
    }
    
    func test_changeIndicator_showsDownWhenPriceDecreases() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 150.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Price decreased")
        
        sut.$symbol
            .dropFirst()
            .sink { symbol in
                if symbol.currentPrice == 100.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 100.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.changeIndicator, .down)
    }
    
    // MARK: - Multiple Updates Tests
    
    func test_multipleUpdates_tracksLatestPrice() async {
        // Given
        let initialSymbol = makeSymbol("AAPL", price: 100.0)
        createSUT(with: initialSymbol)
        
        let expectation = XCTestExpectation(description: "Final price received")
        
        sut.$symbol
            .dropFirst(3) // Skip initial + first 2 updates
            .sink { symbol in
                if symbol.currentPrice == 400.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - multiple updates
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 300.0))
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 400.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbol.currentPrice, 400.0)
        XCTAssertEqual(sut.symbol.previousPrice, 300.0)
    }
}
