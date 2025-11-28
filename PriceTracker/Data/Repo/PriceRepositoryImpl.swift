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
    private let errorsSubject = PassthroughSubject<PriceRepositoryError, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var connectionCancellable: AnyCancellable?
    private var updateTimer: Timer?
    
    init(webSocketDataSource: WebSocketDataSourceProtocol = WebSocketDataSource(),
         priceGenerator: PriceGenerator = .init(),
         symbolGenerator: SymbolGenerator = .init()
    ) {
        self.webSocketDataSource = webSocketDataSource
        self.priceGenerator = priceGenerator
        self.symbolGenerator = symbolGenerator
        setupMessageReceiver()
        setupConnectionMonitoring()
    }

    deinit {
        stopSendingUpdates()
    }
    
    private func sendUpdatesForAllSymbols() {
        for (index, symbol) in symbolGenerator.symbols.enumerated() {
            let delay = Double(index) * 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self else { return }
                let update = self.priceGenerator.generatePriceUpdate(for: symbol)
                self.sendPriceUpdate(update)
            }
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
            errorsSubject.send(.encodingFailed)
        }
    }
    
    private func setupMessageReceiver() {
        let decoder = JSONDecoder()

        webSocketDataSource.receivedMessages
            .compactMap { [weak self] message -> PriceUpdate? in
                guard let data = message.data(using: .utf8) else {
                    self?.errorsSubject.send(.decodingFailed)
                    return nil
                }
                do {
                    return try decoder.decode(PriceUpdate.self, from: data)
                } catch {
                    self?.errorsSubject.send(.decodingFailed)
                    return nil
                }
            }
            .sink { [weak self] update in
                self?.priceUpdatesSubject.send(update)
            }
            .store(in: &cancellables)
    }
    
    private func setupConnectionMonitoring() {
        webSocketDataSource.connectionStatus
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                self?.errorsSubject.send(.connectionLost)
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
    
    var errors: AnyPublisher<PriceRepositoryError, Never> {
        errorsSubject.eraseToAnyPublisher()
    }

    func fetchSymbols() -> [StockSymbol] {
        symbolGenerator.symbols.map { symbol in
            let price = priceGenerator.generatePriceUpdate(for: symbol).price
            let description = symbolGenerator.description(for: symbol)
            // Generate a random previous price to show initial arrow direction
            let randomPreviousPrice = Double.random(in: 10.0...500.0)
            return StockSymbol(
                symbol: symbol,
                description: description,
                currentPrice: price,
                previousPrice: randomPreviousPrice
            )
        }
    }

    func connect() {
        webSocketDataSource.connect()
        
        // Wait for connection before sending updates
        connectionCancellable = webSocketDataSource.connectionStatus
            .filter { $0 == true }
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.startSendingUpdates()
            }
    }

    func disconnect() {
        connectionCancellable?.cancel()
        connectionCancellable = nil
        stopSendingUpdates()
        webSocketDataSource.disconnect()
    }
}
