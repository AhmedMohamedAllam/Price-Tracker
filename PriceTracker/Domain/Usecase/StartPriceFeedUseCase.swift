//
//  StartPriceFeedUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//


import Foundation

final class StartPriceFeedUseCase {
    private let repository: PriceRepositoryProtocol
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() {
        repository.connect()
    }
}
