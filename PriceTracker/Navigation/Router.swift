//
//  Router.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    private let symbolLookup: (String) -> StockSymbol?
    
    init(symbolLookup: @escaping (String) -> StockSymbol?) {
        self.symbolLookup = symbolLookup
    }
    
    // MARK: - Navigation
    
    func navigate(to route: Route) {
        switch route {
        case .feed:
            popToRoot()
        case .symbolDetail(let symbol):
            path.append(symbol)
        }
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    // MARK: - Deep Link Handling
    
    /// Handles a URL by parsing it into a DeepLink and navigating
    func handleDeepLink(url: URL) {
        guard let deepLink = DeepLink.parse(from: url) else { return }
        handle(deepLink: deepLink)
    }
    
    /// Handles a parsed DeepLink
    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .symbol(let id):
            if let symbol = symbolLookup(id) {
                navigate(to: .symbolDetail(symbol))
            }
        }
    }
}
