//
//  StockRowView.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import SwiftUI

struct StockRowView: View {
    let symbol: StockSymbol
    
    var body: some View {
        HStack(spacing: 8) {
            Text(symbol.symbol)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            FlashingPriceView(
                price: symbol.currentPrice,
                changeIndicator: symbol.changeIndicator
            )
            
            changeIndicatorView
                .animation(.easeInOut(duration: 0.3), value: symbol.changeIndicator)
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var changeIndicatorView: some View {
        switch symbol.changeIndicator {
        case .up:
            Image(systemName: "arrow.up")
                .foregroundStyle(.green)
                .fontWeight(.bold)
        case .down:
            Image(systemName: "arrow.down")
                .foregroundStyle(.red)
                .fontWeight(.bold)
        case .none:
            Image(systemName: "arrow.up")
                .fontWeight(.bold)
                .opacity(0)
        }
    }
}

#Preview {
    List {
        StockRowView(symbol: StockSymbol(symbol: "AAPL", description: "Apple Inc.", currentPrice: 150.25, previousPrice: 149.00))
        StockRowView(symbol: StockSymbol(symbol: "GOOGL", description: "Alphabet Inc.", currentPrice: 2800.50, previousPrice: 2850.00))
        StockRowView(symbol: StockSymbol(symbol: "MSFT", description: "Microsoft Corp.", currentPrice: 380.00, previousPrice: nil))
    }
}

