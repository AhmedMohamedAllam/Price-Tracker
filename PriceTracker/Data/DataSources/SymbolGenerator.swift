//
//  SymbolGenerator.swift
//  PriceTracker
//
//  Created by Ahmed Allam on 27/11/2025.
//


struct SymbolGenerator {
    let symbolsData: [String: String] = [
        "AAPL": "Apple Inc. - Technology company that designs consumer electronics, software, and online services.",
        "GOOG": "Alphabet Inc. - Multinational technology company specializing in internet services and AI.",
        "TSLA": "Tesla Inc. - Electric vehicle and clean energy company.",
        "AMZN": "Amazon.com Inc. - E-commerce, cloud computing, and artificial intelligence company.",
        "MSFT": "Microsoft Corporation - Technology company developing software, hardware, and cloud services.",
        "NVDA": "NVIDIA Corporation - Technology company designing graphics processing units and AI chips.",
        "META": "Meta Platforms Inc. - Social media and virtual reality technology company.",
        "NFLX": "Netflix Inc. - Streaming entertainment service company.",
        "AMD": "Advanced Micro Devices Inc. - Semiconductor company developing CPUs and GPUs.",
        "INTC": "Intel Corporation - Multinational semiconductor chip manufacturer.",
        "ORCL": "Oracle Corporation - Enterprise software and cloud computing company.",
        "CRM": "Salesforce Inc. - Cloud-based customer relationship management platform.",
        "ADBE": "Adobe Inc. - Software company known for creative and multimedia products.",
        "CSCO": "Cisco Systems Inc. - Networking hardware and telecommunications equipment company.",
        "AVGO": "Broadcom Inc. - Designer and developer of semiconductor and infrastructure software.",
        "QCOM": "Qualcomm Inc. - Semiconductor and telecommunications equipment company.",
        "TXN": "Texas Instruments Inc. - Semiconductor design and manufacturing company.",
        "AMAT": "Applied Materials Inc. - Supplier of equipment for semiconductor manufacturing.",
        "LRCX": "Lam Research Corporation - Semiconductor equipment manufacturer.",
        "KLAC": "KLA Corporation - Process control and yield management solutions provider.",
        "SNPS": "Synopsys Inc. - Electronic design automation and semiconductor IP company.",
        "CDNS": "Cadence Design Systems Inc. - Electronic design automation software company.",
        "MRVL": "Marvell Technology Inc. - Semiconductor company for data infrastructure.",
        "WDAY": "Workday Inc. - Enterprise cloud applications for finance and HR.",
        "ZS": "Zscaler Inc. - Cloud-based information security company."
    ]
    
    var symbols: [String] {
        Array(symbolsData.keys)
    }
    
    func description(for symbol: String) -> String {
        symbolsData[symbol] ?? "No description available."
    }
}
