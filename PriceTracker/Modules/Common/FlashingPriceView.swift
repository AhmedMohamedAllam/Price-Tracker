//
//  FlashingPriceView.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//

import SwiftUI

struct FlashingPriceView: View {
    let price: Double
    let changeIndicator: StockSymbol.ChangeIndicator
    let font: Font
    let minWidth: CGFloat = 90

    @State private var textColor: Color = .primary
    
    init(
        price: Double,
        changeIndicator: StockSymbol.ChangeIndicator,
        font: Font = .subheadline
    ) {
        self.price = price
        self.changeIndicator = changeIndicator
        self.font = font
    }
    
    var body: some View {
        Text(formattedPrice)
            .font(font)
            .monospacedDigit()
            .foregroundStyle(textColor)
            .contentTransition(.numericText())
            .frame(minWidth: minWidth, alignment: .trailing)
            .animation(.easeInOut(duration: 0.15), value: price)
            .onChange(of: price) { _, _ in
                triggerFlash()
            }
    }
    
    private var formattedPrice: String {
        String(format: "$%.2f", price)
    }
    
    private func triggerFlash() {
        switch changeIndicator {
        case .up:
            textColor = .green
        case .down:
            textColor = .red
        case .none:
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.15)) {
                textColor = .primary
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FlashingPriceView(
            price: 150.25,
            changeIndicator: .up
        )
        
        FlashingPriceView(
            price: 2800.50,
            changeIndicator: .down,
            font: .system(size: 48, weight: .bold, design: .rounded)
        )
    }
}

