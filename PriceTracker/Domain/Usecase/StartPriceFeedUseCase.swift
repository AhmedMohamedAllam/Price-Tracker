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
    
    var connectionStatus: AnyPublisher<Bool, Never> {
        repository.connectionStatus
    }
    
    var priceUpdates: AnyPublisher<PriceUpdate, Never> {
        repository.priceUpdates
    }
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() {
        repository.connect()
    }
}
