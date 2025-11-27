//
//  StockSymbol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 26/11/2025.
//

import Foundation

struct StockSymbol: Identifiable, Hashable, Comparable {
    var id: String { symbol }
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

    static func < (lhs: StockSymbol, rhs: StockSymbol) -> Bool {
        return lhs.currentPrice < rhs.currentPrice
    }

}
