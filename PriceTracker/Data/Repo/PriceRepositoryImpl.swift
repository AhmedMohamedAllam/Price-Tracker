//
//  PriceRepositoryImpl.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import Combine

final class PriceRepositoryImpl {
    private let webSocketDataSource: WebSocketDataSourceProtocol
    private let priceGenerator: PriceGenerator
    private let symbolGenerator: SymbolGenerator

    private let priceUpdatesSubject = PassthroughSubject<PriceUpdate, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var updateTimer: Timer?
    
    init(webSocketDataSource: WebSocketDataSourceProtocol = WebSocketDataSource(),
         priceGenerator: PriceGenerator = .init(),
         symbolGenerator: SymbolGenerator = .init()
    ) {
        self.webSocketDataSource = webSocketDataSource
        self.priceGenerator = priceGenerator
        self.symbolGenerator = symbolGenerator
        setupMessageReceiver()
    }

    deinit {
        stopSendingUpdates()
    }
    
    private func sendUpdatesForAllSymbols() {
        for symbol in symbolGenerator.symbols {
            let update = priceGenerator.generatePriceUpdate(for: symbol)
            sendPriceUpdate(update)
        }
    }
    
    private func sendPriceUpdate(_ update: PriceUpdate) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(update)
            if let jsonString = String(data: data, encoding: .utf8) {
                webSocketDataSource.send(jsonString)
            }
        } catch {
            print("Failed to encode price update: \(error)")
        }
    }
    
    private func setupMessageReceiver() {
        let decoder = JSONDecoder()

        webSocketDataSource.receivedMessages
            .compactMap {
                guard let data = $0.data(using: .utf8) else { return nil }
                return try? decoder.decode(PriceUpdate.self, from: data)
            }
            .sink { [weak self] update in
                self?.priceUpdatesSubject.send(update)
            }
            .store(in: &cancellables)
    }

    private func startSendingUpdates() {
        sendUpdatesForAllSymbols()

        // Then send every 2 seconds
        updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.sendUpdatesForAllSymbols()
        }
    }

    private func stopSendingUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}


extension PriceRepositoryImpl: PriceRepositoryProtocol {
    var priceUpdates: AnyPublisher<PriceUpdate, Never> {
        priceUpdatesSubject.eraseToAnyPublisher()
    }

    var connectionStatus: AnyPublisher<Bool, Never> {
        webSocketDataSource.connectionStatus
    }

    func connect() {
        webSocketDataSource.connect()
        startSendingUpdates()
    }

    func disconnect() {
        stopSendingUpdates()
        webSocketDataSource.disconnect()
    }
}
