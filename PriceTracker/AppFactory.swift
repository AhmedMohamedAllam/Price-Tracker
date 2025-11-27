//
//  AppFactory.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation

// This is a Simualation instead of Factory SPM
struct AppFactory {
    private static let priceRepository = PriceRepositoryImpl()
    
    static func makeFeedViewModel() -> FeedViewModel {
        let fetchSymbolsUseCase = FetchSymbolsUseCase(repository: priceRepository)
        let priceFeedUseCase = PriceFeedUseCase(repository: priceRepository)
        
        return FeedViewModel(
            fetchSymbolsUseCase: fetchSymbolsUseCase,
            priceFeedUseCase: priceFeedUseCase
        )
    }
}

