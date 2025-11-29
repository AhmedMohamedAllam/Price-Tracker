//
//  FetchSymbolsUseCaseProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 29/11/2025.
//

import Foundation

protocol FetchSymbolsUseCaseProtocol {
    func execute() -> [StockSymbol]
}

