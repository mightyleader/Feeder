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
    private var historyFormat: Date.FormatStyle = Date.FormatStyle(date: .abbreviated,
                                                                   time: .shortened)
    
    private var showTodayOnly: Bool
    private var filterMode: FeederDateFilter
    
    init(limitingDate: Date, showTodayOnly: Bool, filterMode: FeederDateFilter) {
        self.filterMode = filterMode

        self.showTodayOnly = showTodayOnly
        _feeds = Query(filter: #Predicate<Feed> { feed in
            feed.timestamp >= limitingDate //self.dateQueryRange.contains(feed.timestamp)
        }, sort: \Feed.timestamp)
        //        self.selectedDate = .now
    }
    
    /*
     a single date - all the feeds within that day
     a range of dates - all the feeds within the supplied range.
     basically these are the same thing!
     */
    init(dateQueryRange: ClosedRange<Date>, filterMode: FeederDateFilter) {
        self.filterMode = filterMode
        self.showTodayOnly = false
        _feeds = Query(filter: #Predicate<Feed> { feed in
//            dateQueryRange.contains(feed.timestamp)
            feed.timestamp >= dateQueryRange.lowerBound && feed.timestamp <= dateQueryRange.upperBound
        }, sort: \Feed.timestamp)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.feeds) { feed in
                    NavigationLink {
                        EditFeedSheetView(feed: feed)
                    } label: {
                        HStack {
                            Text("\(feed.timestamp, format: historyFormat)")
                                .foregroundStyle(.gray)
                                .font(.caption)
                            Spacer()
                            SourceLabel(source: feed.source)
                            FeedLabel(qty: feed.qty_as_int)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            TotalView(qty_ml: total(items: self.feeds), highlightTarget: showTodayOnly, filterMode: self.filterMode)
        }
    }
    
    private func total(items: [Feed]) -> Int {
        items.map { item in
            item.qty_as_int
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
    
    //Returns an array of Day structs, each Day has a Date and a list of feeds for that date.
//    private func structuredData(fromFeeds feeds: [Feed]) -> [Day] {
//        let dates = uniqueDates(fromFeeds: feeds)
//        var returnStructuredData = Set<Day>()
//        for date in dates {
//            returnStructuredData.insert(Day(date: date,
//                                            feeds: self.match(Date: date,toFeeds: feeds)))
//            
//        }
//        return Array(returnStructuredData).sorted { $0.date > $1.date }
//    }
    
    //Return an array of unique days as Dates.
    private func uniqueDates(fromFeeds feeds: [Feed]) -> [Date] {
        let dates = feeds.map { feed in
            Calendar.autoupdatingCurrent.startOfDay(for: feed.timestamp)
        }
        return Array(Set(dates))
    }
    
    
    //Finds which Feeds happened on a specific date.
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
    FeedsView(limitingDate: Date.distantPast, showTodayOnly: true, filterMode: .today)
}
