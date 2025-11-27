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
    
    static func makeFeedViewModel() -> FeedViewModel {
        return FeedViewModel(
            fetchSymbolsUseCase: fetchSymbolsUseCase,
            priceFeedUseCase: priceFeedUseCase
        )
    }
    
    static func makeSymbolDetailViewModel(initialSymbol: StockSymbol) -> SymbolDetailViewModel {
        return SymbolDetailViewModel(
            initialSymbol: initialSymbol,
            priceFeedUseCase: priceFeedUseCase
        )
    }
}
