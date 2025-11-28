//
//  FeedViewModelTests.swift
//  PriceTrackerTests
//
//  Created by Ahmed Allam.
//

import XCTest
import Combine
@testable import PriceTracker

@MainActor
final class FeedViewModelTests: XCTestCase {
    
    private var mockRepository: MockPriceRepository!
    private var fetchSymbolsUseCase: FetchSymbolsUseCase!
    private var priceFeedUseCase: PriceFeedUseCase!
    private var sut: FeedViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPriceRepository()
        fetchSymbolsUseCase = FetchSymbolsUseCase(repository: mockRepository)
        priceFeedUseCase = PriceFeedUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        priceFeedUseCase = nil
        fetchSymbolsUseCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createSUT() {
        sut = FeedViewModel(
            fetchSymbolsUseCase: fetchSymbolsUseCase,
            priceFeedUseCase: priceFeedUseCase
        )
    }
    
    private func makeSymbol(_ symbol: String, price: Double) -> StockSymbol {
        StockSymbol(
            symbol: symbol,
            description: "Test \(symbol)",
            currentPrice: price,
            previousPrice: nil
        )
    }
    
    // MARK: - Initial State Tests
    
    func test_init_loadsSymbolsFromUseCase() {
        // Given
        let symbols = [
            makeSymbol("AAPL", price: 150.0),
            makeSymbol("GOOG", price: 100.0)
        ]
        mockRepository.symbolsToReturn = symbols
        
        // When
        createSUT()
        
        // Then
        XCTAssertEqual(sut.symbols.count, 2)
    }
    
    func test_init_symbolsAreSortedByPriceDescending() {
        // Given
        let symbols = [
            makeSymbol("AAPL", price: 100.0),
            makeSymbol("GOOG", price: 300.0),
            makeSymbol("TSLA", price: 200.0)
        ]
        mockRepository.symbolsToReturn = symbols
        
        // When
        createSUT()
        
        // Then
        XCTAssertEqual(sut.symbols[0].symbol, "GOOG")
        XCTAssertEqual(sut.symbols[1].symbol, "TSLA")
        XCTAssertEqual(sut.symbols[2].symbol, "AAPL")
    }
    
    func test_init_isFeedRunningIsFalse() {
        // Given
        mockRepository.symbolsToReturn = []
        
        // When
        createSUT()
        
        // Then
        XCTAssertFalse(sut.isFeedRunning)
    }
    
    func test_init_isConnectedIsFalse() {
        // Given
        mockRepository.symbolsToReturn = []
        
        // When
        createSUT()
        
        // Then
        XCTAssertFalse(sut.isConnected)
    }
    
    // MARK: - Start/Stop Feed Tests
    
    func test_startFeed_setsIsFeedRunningToTrue() {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        
        // When
        sut.startFeed()
        
        // Then
        XCTAssertTrue(sut.isFeedRunning)
    }
    
    func test_startFeed_callsRepositoryConnect() {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        
        // When
        sut.startFeed()
        
        // Then
        XCTAssertEqual(mockRepository.connectCallCount, 1)
    }
    
    func test_stopFeed_setsIsFeedRunningToFalse() {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        sut.startFeed()
        
        // When
        sut.stopFeed()
        
        // Then
        XCTAssertFalse(sut.isFeedRunning)
    }
    
    func test_stopFeed_callsRepositoryDisconnect() {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        sut.startFeed()
        
        // When
        sut.stopFeed()
        
        // Then
        XCTAssertEqual(mockRepository.disconnectCallCount, 1)
    }
    
    // MARK: - Price Update Tests
    
    func test_priceUpdate_updatesMatchingSymbol() async {
        // Given
        let symbols = [
            makeSymbol("AAPL", price: 150.0),
            makeSymbol("GOOG", price: 100.0)
        ]
        mockRepository.symbolsToReturn = symbols
        createSUT()
        sut.startFeed()
        
        let expectation = XCTestExpectation(description: "Price update received")
        
        sut.$symbols
            .dropFirst()
            .sink { symbols in
                if symbols.first(where: { $0.symbol == "AAPL" })?.currentPrice == 200.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        let updatedSymbol = sut.symbols.first { $0.symbol == "AAPL" }
        XCTAssertEqual(updatedSymbol?.currentPrice, 200.0)
    }
    
    func test_priceUpdate_setsPreviousPrice() async {
        // Given
        let symbols = [makeSymbol("AAPL", price: 150.0)]
        mockRepository.symbolsToReturn = symbols
        createSUT()
        sut.startFeed()
        
        let expectation = XCTestExpectation(description: "Price update with previous price")
        
        sut.$symbols
            .dropFirst()
            .sink { symbols in
                if symbols.first?.previousPrice == 150.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        let updatedSymbol = sut.symbols.first { $0.symbol == "AAPL" }
        XCTAssertEqual(updatedSymbol?.previousPrice, 150.0)
    }
    
    func test_priceUpdate_maintainsSortingByPrice() async {
        // Given
        let symbols = [
            makeSymbol("AAPL", price: 300.0),
            makeSymbol("GOOG", price: 200.0),
            makeSymbol("TSLA", price: 100.0)
        ]
        mockRepository.symbolsToReturn = symbols
        createSUT()
        sut.startFeed()
        
        // Initial order should be AAPL, GOOG, TSLA
        XCTAssertEqual(sut.symbols[0].symbol, "AAPL")
        
        let expectation = XCTestExpectation(description: "Sorting after price update")
        
        sut.$symbols
            .dropFirst()
            .sink { symbols in
                // After TSLA goes to 500, it should be first
                if symbols.first?.symbol == "TSLA" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - TSLA price jumps to highest
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "TSLA", price: 500.0))
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.symbols[0].symbol, "TSLA")
        XCTAssertEqual(sut.symbols[0].currentPrice, 500.0)
    }
    
    func test_priceUpdate_ignoredWhenFeedStopped() async {
        // Given
        let symbols = [makeSymbol("AAPL", price: 150.0)]
        mockRepository.symbolsToReturn = symbols
        createSUT()
        
        // Don't start feed - feed is stopped by default
        
        // When
        mockRepository.simulatePriceUpdate(PriceUpdate(symbol: "AAPL", price: 200.0))
        
        // Give some time for any potential update
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - price should remain unchanged
        let symbol = sut.symbols.first { $0.symbol == "AAPL" }
        XCTAssertEqual(symbol?.currentPrice, 150.0)
    }
    
    // MARK: - Connection Status Tests
    
    func test_connectionStatus_updatesIsConnected() async {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        
        let expectation = XCTestExpectation(description: "Connection status updated")
        
        sut.$isConnected
            .dropFirst()
            .sink { isConnected in
                if isConnected {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulateConnectionStatus(true)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(sut.isConnected)
    }
    
    func test_connectionStatus_updatesToDisconnected() async {
        // Given
        mockRepository.symbolsToReturn = []
        createSUT()
        mockRepository.simulateConnectionStatus(true)
        
        // Wait for connected state
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        let expectation = XCTestExpectation(description: "Disconnection status updated")
        
        sut.$isConnected
            .dropFirst()
            .sink { isConnected in
                if !isConnected {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockRepository.simulateConnectionStatus(false)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isConnected)
    }
}
