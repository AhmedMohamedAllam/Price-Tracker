//
//  PriceTrackerApp.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 25/11/2025.
//

import SwiftUI

@main
struct PriceTrackerApp: App {
    @StateObject private var viewModel = AppFactory.makeFeedViewModel()
    
    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: viewModel)
        }
    }
}
