//
//  SymbolDetailView.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import SwiftUI

struct SymbolDetailView: View {
    @StateObject var viewModel: SymbolDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            priceSection
            descriptionSection
            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.symbol.symbol)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var priceSection: some View {
        HStack(spacing: 12) {
            Text(formattedPrice)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: viewModel.symbol.currentPrice)
            
            changeIndicatorView
                .animation(.easeInOut(duration: 0.3), value: viewModel.symbol.changeIndicator)
        }
    }
    
    private var formattedPrice: String {
        String(format: "$%.2f", viewModel.symbol.currentPrice)
    }
    
    @ViewBuilder
    private var changeIndicatorView: some View {
        switch viewModel.symbol.changeIndicator {
        case .up:
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.green)
        case .down:
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.red)
        case .none:
            Image(systemName: "minus.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.gray)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(viewModel.symbol.description)
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(
            viewModel: AppFactory.makeSymbolDetailViewModel(
                initialSymbol: StockSymbol(
                    symbol: "AAPL",
                    description: "Apple Inc. - Technology company.",
                    currentPrice: 150.25,
                    previousPrice: 149.00
                )
            )
        )
    }
}
