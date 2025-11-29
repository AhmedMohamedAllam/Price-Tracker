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
    
    private let fetchSymbolsUseCase: any FetchSymbolsUseCaseProtocol
    private let priceFeedUseCase: any PriceFeedUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var priceUpdatesCancellable: AnyCancellable?
    
    init(fetchSymbolsUseCase: any FetchSymbolsUseCaseProtocol,
         priceFeedUseCase: any PriceFeedUseCaseProtocol) {
        self.fetchSymbolsUseCase = fetchSymbolsUseCase
        self.priceFeedUseCase = priceFeedUseCase

        loadSymbols()
        setupObservers()
    }
    
    private func loadSymbols() {
        symbols = fetchSymbolsUseCase.execute().sorted(by: >)
    }
    
    func startFeed() {
        priceUpdatesCancellable = priceFeedUseCase.priceUpdates
            .sink { [weak self] update in
                self?.updateSymbol(update)
            }
        priceFeedUseCase.start()
        isFeedRunning = true
    }
    
    func stopFeed() {
        priceUpdatesCancellable?.cancel()
        priceUpdatesCancellable = nil
        priceFeedUseCase.stop()
        isFeedRunning = false
    }
    
    private func setupObservers() {
        priceFeedUseCase.stream
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
            description: old.description,
            currentPrice: update.price,
            previousPrice: old.currentPrice
        )
    }

    private func updateSymbol(_ update: PriceUpdate) {
        if let index = symbols.firstIndex(where: { $0.symbol == update.symbol }) {
            updateSymbolPrice(index, update)
        }
        symbols.sort(by: >)
    }
}
