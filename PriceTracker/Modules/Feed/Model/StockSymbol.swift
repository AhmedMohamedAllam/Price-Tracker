//
//  StockSymbol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 26/11/2025.
//

import Foundation

struct StockSymbol: Identifiable {
    let id = UUID()
    let symbol: String
    let currentPrice: Double
    let previousPrice: Double?
    
    var changeIndicator: ChangeIndicator {
        guard let previous = previousPrice, currentPrice != previous else { return .none }
        return currentPrice > previous ? .up : .down
    }

    enum ChangeIndicator {
        case up, down, none
    }
}
