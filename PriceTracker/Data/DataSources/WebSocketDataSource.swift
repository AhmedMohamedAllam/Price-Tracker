//
//  WebSocketDataSource.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 26/11/2025.
//

import Foundation
import Combine

protocol WebSocketDataSourceProtocol {
    var connectionStatus: AnyPublisher<Bool, Never> { get }
    var receivedMessages: AnyPublisher<String, Never> { get }
    func connect()
    func disconnect()
    func send(_ message: String)
}


final class WebSocketDataSource: NSObject {
    private let url = URL(string: "wss://ws.postman-echo.com/raw")!
    private var task: URLSessionWebSocketTask?
    private var session: URLSession?

    private let connectionStatusSubject = CurrentValueSubject<Bool, Never>(false)
    private let receivedMessagesSubject = PassthroughSubject<String, Never>()

    var connectionStatus: AnyPublisher<Bool, Never> {
        connectionStatusSubject.eraseToAnyPublisher()
    }

    var receivedMessages: AnyPublisher<String, Never> {
        receivedMessagesSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
}

extension WebSocketDataSource: WebSocketDataSourceProtocol {

    func connect() {
        disconnect() // Ensure clean state
        task = session?.webSocketTask(with: url)
        task?.resume()
        startReceivingMessages()
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
        connectionStatusSubject.send(false)
    }
    
    func send(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        task?.send(message) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            }
        }
    }

    private func startReceivingMessages() {
        task?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                if case let .string(text) = message {
                    self.receivedMessagesSubject.send(text)
                } else {
                    print("Received message not handled", message as Any)
                }
                // Continue receiving messages
                self.startReceivingMessages()
                
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                self.connectionStatusSubject.send(false)
            }
        }
    }
}


extension WebSocketDataSource: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        connectionStatusSubject.send(true)
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        connectionStatusSubject.send(false)
    }
}

