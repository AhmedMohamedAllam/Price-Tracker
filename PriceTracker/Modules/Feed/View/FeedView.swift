//
//  FeedView.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List(viewModel.symbols) { symbol in
                NavigationLink(value: symbol) {
                    StockRowView(symbol: symbol)
                }
            }
            .navigationDestination(for: StockSymbol.self) { symbol in
                SymbolDetailView(
                    viewModel: AppFactory.makeSymbolDetailViewModel(initialSymbol: symbol)
                )
            }
            .navigationTitle("Price Feed")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    connectionStatusView
                }
                ToolbarItem(placement: .topBarTrailing) {
                    feedToggleButton
                }
            }
        }
    }
    
    private var connectionStatusView: some View {
        Circle()
            .fill(viewModel.isConnected ? .green : .red)
    }
    
    private var feedToggleButton: some View {
        Button {
            if viewModel.isFeedRunning {
                viewModel.stopFeed()
            } else {
                viewModel.startFeed()
            }
        } label: {
            Text(viewModel.isFeedRunning ? "Stop" : "Start")
        }
    }
}
