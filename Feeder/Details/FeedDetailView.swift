//
//  FeedDetailView.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI
import Charts

struct FeedDetailView: View {
    var items: [Feed]
    
    var body: some View {
        VStack {
            Chart(items) { item in
                SectorMark(angle: .value("Feeds", item.qty_as_int),
                           innerRadius: .ratio(0.7),
                           angularInset: 1.0)
                .foregroundStyle(by: .value("Source", item.source.rawValue))
                .cornerRadius(5.0)
                .annotation (position: .overlay) {
                    Text("\(item.qty_as_int)ml")
                }
            }
            .foregroundStyle(.white)
            .padding()
        }
        .padding()
    }
}

#Preview {
    FeedDetailView(items: [Feed(timestamp: Date(),
                                qty_ml: .fifty,
                                source: .formula_standard)])
}

extension FeedDetailView {
    
}
