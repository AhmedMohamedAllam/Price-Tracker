//
//  DeepLink.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import Foundation

enum DeepLink: Equatable {
    case symbol(id: String)

    static func parse(from url: URL) -> DeepLink? {
        guard url.scheme == "stocks" else { return nil }
        
        guard let host = url.host else { return nil }
        
        switch host {
        case "symbol":
            let symbolId = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !symbolId.isEmpty else { return nil }
            return .symbol(id: symbolId)
        default:
            return nil
        }
    }
}

