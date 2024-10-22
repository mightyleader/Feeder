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
    
    private var todayFormat: Date.FormatStyle = Date.FormatStyle(date: .none,
                                                                 time: .standard)
    private var historyFormat: Date.FormatStyle = Date.FormatStyle(date: .complete,
                                                                   time: .shortened)
    
    private var showTodayOnly: Bool
                            

    init(limitingDate: Date, showTodayOnly: Bool) {
        self.showTodayOnly = showTodayOnly
        _feeds = Query(filter: #Predicate<Feed> { feed in
            feed.timestamp >= limitingDate
        }, sort: \Feed.timestamp)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.feeds) { feed in
//                    NavigationLink {
//                        FeedDetailView(items: self.feeds)
//                    } label: {
                        HStack {
                            Text("\(feed.timestamp, format: showTodayOnly ? todayFormat : historyFormat)").foregroundStyle(.gray)
                            Spacer()
                            SourceLabel(source: feed.source)
                            FeedLabel(qtys: feed.qty_ml)
                        }
//                    }
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
    FeedsView(limitingDate: Date.distantPast, showTodayOnly: true)
}
