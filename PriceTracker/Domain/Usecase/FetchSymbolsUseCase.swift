//
//  FetchSymbolsUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation

final class FetchSymbolsUseCase: FetchSymbolsUseCaseProtocol {
    private let repository: PriceRepositoryProtocol
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> [StockSymbol] {
        repository.fetchSymbols()
    }
}

