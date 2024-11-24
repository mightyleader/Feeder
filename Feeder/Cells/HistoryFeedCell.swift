//
//  DateCell.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct HistoryFeedCell: View {
    var feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
    }
    
    var body: some View {
        VStack {
            Text("\(feed.timestamp, format: Date.FormatStyle(date: .abbreviated, time:.shortened))").foregroundStyle(.gray)
            HStack {
                SourceLabel(source: feed.source)
                Spacer()
                FeedLabel(qtys: feed.qty_ml)
            }
        }
    }
}

#Preview {
    HistoryFeedCell(feed: Feed(timestamp: Date.now, qty_ml: .eighty, source: .formula_enriched))
}
