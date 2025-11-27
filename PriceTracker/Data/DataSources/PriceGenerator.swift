//
//  PriceGenerator.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 26/11/2025.
//

import Foundation

class PriceGenerator {
    private let minPrice: Double = 10.0
    private let maxPrice: Double = 500.0
    
    init() {}
    
    func generateRandomPrice() -> Double {
        return Double.random(in: minPrice...maxPrice)
    }
    
    func generatePriceUpdate(for symbol: String) -> PriceUpdate {
        return PriceUpdate(
            symbol: symbol,
            price: generateRandomPrice()
        )
    }
}
