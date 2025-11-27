//
//  PriceFeedUseCase.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

final class PriceFeedUseCase {
    private let repository: PriceRepositoryProtocol
    private var priceUpdatesCancellable: AnyCancellable?
    
    var connectionStatus: AnyPublisher<Bool, Never> {
        repository.connectionStatus
    }
    
    init(repository: PriceRepositoryProtocol) {
        self.repository = repository
    }
    
    func start(onUpdate: @escaping (PriceUpdate) -> Void) {
        priceUpdatesCancellable = repository.priceUpdates
            .receive(on: DispatchQueue.main)
            .sink { update in
                onUpdate(update)
            }
        repository.connect()
    }
    
    func stop() {
        priceUpdatesCancellable?.cancel()
        priceUpdatesCancellable = nil
        repository.disconnect()
    }
}

