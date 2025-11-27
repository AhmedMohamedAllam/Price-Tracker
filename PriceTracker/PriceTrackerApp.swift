//
//  PriceTrackerApp.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 25/11/2025.
//

import SwiftUI

@main
struct PriceTrackerApp: App {
    private let router = AppFactory.router
    
    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: AppFactory.feedViewModel)
                .environmentObject(router)
                .onOpenURL { url in
                    router.handleDeepLink(url: url)
                }
        }
    }
}
