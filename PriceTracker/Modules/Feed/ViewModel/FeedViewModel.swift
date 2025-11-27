//
//  FeedViewModel.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

@MainActor
final class FeedViewModel: ObservableObject {
    @Published private(set) var symbols: [StockSymbol] = []
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isFeedRunning: Bool = false
    
    private let fetchSymbolsUseCase: FetchSymbolsUseCase
    private let priceFeedUseCase: PriceFeedUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchSymbolsUseCase: FetchSymbolsUseCase,
         priceFeedUseCase: PriceFeedUseCase) {
        self.fetchSymbolsUseCase = fetchSymbolsUseCase
        self.priceFeedUseCase = priceFeedUseCase

        loadSymbols()
        setupObservers()
    }
    
    private func loadSymbols() {
        symbols = fetchSymbolsUseCase.execute().sorted(by: >)
    }
    
    func startFeed() {
        priceFeedUseCase.start { [weak self] update in
            self?.updateSymbol(update)
        }
        isFeedRunning = true
    }
    
    func stopFeed() {
        priceFeedUseCase.stop()
        isFeedRunning = false
    }
    
    private func setupObservers() {
        priceFeedUseCase.connectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isConnected = status
            }
            .store(in: &cancellables)
    }
    
    private func updateSymbolPrice(_ index: Array<StockSymbol>.Index, _ update: PriceUpdate) {
        let old = symbols[index]
        symbols[index] = StockSymbol(
            symbol: update.symbol,
            currentPrice: update.price,
            previousPrice: old.currentPrice
        )
    }

    private func addSymbolPrice(_ update: PriceUpdate) {
        symbols.append(StockSymbol(
            symbol: update.symbol,
            currentPrice: update.price,
            previousPrice: nil
        ))
    }

    private func updateSymbol(_ update: PriceUpdate) {
        if let index = symbols.firstIndex(where: { $0.symbol == update.symbol }) {
            updateSymbolPrice(index, update)
        } else {
            addSymbolPrice(update)
        }
        symbols.sort(by: >)
    }
}
