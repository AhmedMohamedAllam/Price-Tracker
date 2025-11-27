//
//  StartPriceFeedUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//


import Foundation
import Combine

final class StartPriceFeedUseCase: UsecaseProtocol {
    private let repository: PriceRepositoryProtocol
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<PriceUpdate, Never>{
        repository.connect()
        return repository.priceUpdates
    }
}
