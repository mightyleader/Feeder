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
    @Query private var feeds: [Feed]

    init(limitingDate: Date) {
        print("0. FeedsView init called")
        _feeds = Query(filter: #Predicate<Feed> { feed in
            feed.timestamp >= limitingDate
        }, sort: \Feed.timestamp)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(structuredData(fromFeeds: self.feeds)) { day in
                    Section(header:HStack {Text(day.date,format: Date.FormatStyle(date: .abbreviated,time: .none))
                        Text(String(day.feeds.count))})
                    {
                        ForEach(day.feeds) { feed in
                            HStack {
                                Text("\(feed.timestamp, format: Date.FormatStyle(date: .none, time: .standard))").foregroundStyle(.gray)
                                FeedLabel(qtys: feed.qty_ml)
                                SourceLabel(source: feed.source)
                            }
                        }
                        .foregroundStyle(.gray)
                    }
                }
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

extension FeedsView {
    
    private func setOfDays(fromFeeds feeds: [Feed]) -> [Date] {
        let dates = feeds.map { feed in
            Calendar.autoupdatingCurrent.startOfDay(for: feed.timestamp)
        }
        return Array(Set(dates))
    }
    
    private func structuredData(fromFeeds feeds: [Feed]) -> [Day] {
        let dates = setOfDays(fromFeeds: feeds)
        var returnStructuredData = Set<Day>()
        for date in dates {
            returnStructuredData.insert(Day(date: date,
                                            feeds: self.match(Date: date,
                                                              toFeeds: feeds)))
            
        }
        return Array(returnStructuredData).sorted { $0.date > $1.date }
    }
    
    private func match(Date date: Date, toFeeds feeds: [Feed]) -> [Feed] {
        var matchingFeeds = [Feed]()
        for feed in feeds {
            if Calendar.autoupdatingCurrent.isDate(feed.timestamp, inSameDayAs: date) {
                matchingFeeds.append(feed)
            }
        }
        return matchingFeeds
    }
}

#Preview {
    FeedsView(limitingDate: Date.distantPast)
}
