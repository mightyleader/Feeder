//
//  FeedsView.swift
//  Feeder
//
//  Created by Rob Stearn on 12/10/2024.
//

import SwiftUI
import SwiftData

struct FeedsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Feed.timestamp, order: .forward) private var feeds: [Feed]
    
    init(limitingDate: Date) {
        _feeds = Query(filter: #Predicate<Feed> { feed in
            feed.timestamp >= limitingDate
        }, sort: \Feed.timestamp)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(feeds) { item in
                    NavigationLink {
                        VStack {
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .complete, time: .standard))")
                                .font(.headline)
                            FeedLabel(qtys: item.qty_ml)
                            SourceLabel(source: item.source)
                        }
                        .padding()
                    } label: {
                        HStack {
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            FeedLabel(qtys: item.qty_ml)
                            SourceLabel(source: item.source)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            TotalView(qty_ml: total(items: self.feeds))
        }
    }
    
    private func total(items: [Feed]) -> Int {
        items.map { item in
            Int(item.qty_ml.rawValue)!
        }.reduce(0, +)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(feeds[index])
            }
        }
    }
}

#Preview {
    FeedsView(limitingDate: Date.distantPast)
}
