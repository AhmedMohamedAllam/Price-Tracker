//
//  SymbolDetailViewModel.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

@MainActor
final class SymbolDetailViewModel: ObservableObject {
    @Published private(set) var symbol: StockSymbol
    
    private let priceFeedUseCase: PriceFeedUseCase
    private var cancellable: AnyCancellable?
    
    init(initialSymbol: StockSymbol, priceFeedUseCase: PriceFeedUseCase) {
        self.symbol = initialSymbol
        self.priceFeedUseCase = priceFeedUseCase
        
        subscribeToUpdates()
    }
    
    private func subscribeToUpdates() {
        cancellable = priceFeedUseCase.priceUpdates
            .filter { [weak self] update in
                update.symbol == self?.symbol.symbol
            }
            .sink { [weak self] update in
                self?.updatePrice(update)
            }
    }
    
    private func updatePrice(_ update: PriceUpdate) {
        symbol = StockSymbol(
            symbol: symbol.symbol,
            description: symbol.description,
            currentPrice: update.price,
            previousPrice: symbol.currentPrice
        )
    }
    
    deinit {
        cancellable?.cancel()
    }
}

