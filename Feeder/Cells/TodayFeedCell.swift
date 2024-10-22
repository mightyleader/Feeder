//
//  FeedCell.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct TodayFeedCell: View {
    var feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
    }
    
    var body: some View {
        HStack {
            Text("\(feed.timestamp, format: Date.FormatStyle(date: .none,  time: .standard))").foregroundStyle(.gray)
            Spacer()
            SourceLabel(source: feed.source)
            FeedLabel(qtys: feed.qty_ml)
        }
    }
}

#Preview {
    TodayFeedCell(feed: Feed(timestamp: Date.now, qty_ml: .eighty, source: .formula_enriched))
}
