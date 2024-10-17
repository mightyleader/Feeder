//
//  FeedDetailView.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI
import Charts

struct FeedDetailView: View {
    var items: [Item]
    var body: some View {
        VStack {
            Chart(items, id: \.timestamp) { dataItem in
                BarMark(x: .value("Date", dataItem.timestamp),
                        y: .value("Feed (ml)", Int(dataItem.qty_ml.rawValue)!))
                .foregroundStyle(by: .value("Source", dataItem.source.rawValue))
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    FeedDetailView(items: [Item(timestamp: Date(),
                                qty_ml: .fifty,
                                source: .formula_standard)])
}
