//
//  PriceFeedUseCaseProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 29/11/2025.
//

import Foundation
import Combine

protocol PriceFeedUseCaseProtocol {
    var stream: AnyPublisher<Bool, Never> { get }
    var priceUpdates: AnyPublisher<PriceUpdate, Never> { get }
    func start()
    func stop()
}

