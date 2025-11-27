//
//  AppFactory.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation

// This is a Simulation instead of Factory SPM
struct AppFactory {
    private static let priceRepository = PriceRepositoryImpl()
    private static let fetchSymbolsUseCase = FetchSymbolsUseCase(repository: priceRepository)
    
    /// Shared instance - both ViewModels subscribe to the same price updates
    static let priceFeedUseCase = PriceFeedUseCase(repository: priceRepository)
    
    /// Shared FeedViewModel instance
    static let feedViewModel = FeedViewModel(
        fetchSymbolsUseCase: fetchSymbolsUseCase,
        priceFeedUseCase: priceFeedUseCase
    )
    
    /// Shared Router instance with symbol lookup
    static let router = Router { symbolId in
        feedViewModel.symbols.first { $0.symbol == symbolId }
    }
    
    static func makeSymbolDetailViewModel(initialSymbol: StockSymbol) -> SymbolDetailViewModel {
        return SymbolDetailViewModel(
            initialSymbol: initialSymbol,
            priceFeedUseCase: priceFeedUseCase
        )
    }
}
