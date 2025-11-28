//
//  PriceFeedUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

final class PriceFeedUseCase: StreamingUsecaseProtocol {

    private let repository: PriceRepositoryProtocol
    
    var stream: AnyPublisher<Bool, Never> {
        repository.connectionStatus
    }
    
    /// Publisher that multiple ViewModels can subscribe to
    var priceUpdates: AnyPublisher<PriceUpdate, Never> {
        repository.priceUpdates
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func start() {
        repository.connect()
    }
    
    func stop() {
        repository.disconnect()
    }
}
