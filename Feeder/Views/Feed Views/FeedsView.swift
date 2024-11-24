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
    @State private var selectedDate: Date
    @State private var showDatePicker: Bool = false
    
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
            feed.timestamp >= limitingDate
        }, sort: \Feed.timestamp)
        self.selectedDate = .now
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.feeds) { feed in
                    NavigationLink {
                        EditFeedSheetView(feed: feed)
                    } label: {
                        HStack {
                            Text("\(feed.timestamp, format: historyFormat)").foregroundStyle(.gray)
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
        .sheet(isPresented: $showDatePicker) {
            FeedDatePickerView(date: $selectedDate)
                .presentationDetents([.medium])
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
    FeedsView(limitingDate: Date.distantPast, showTodayOnly: true, filterMode: .today)
}
