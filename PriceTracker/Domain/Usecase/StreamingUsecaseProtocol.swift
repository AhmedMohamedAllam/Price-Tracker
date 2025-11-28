//
//  StreamingUsecaseProtocol.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 28/11/2025.
//

import Combine

public protocol StreamingUsecaseProtocol {
    associatedtype Output
    
    var stream: AnyPublisher<Output, Never> { get }
    func start()
    func stop()
}
