//
//  StopPriceFeedUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//


import Foundation

final class StopPriceFeedUseCase: UsecaseProtocol {
    private let repository: PriceRepositoryProtocol
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() {
        repository.disconnect()
    }
}
