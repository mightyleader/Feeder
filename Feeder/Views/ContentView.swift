//
//  ContentView.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showTodayOnly: Bool = true
    @State private var showAddItemSheet: Bool = false
    
    @Query(sort: \Feed.timestamp, order: .forward) private var items: [Feed]
    
    var calendar: Calendar = .autoupdatingCurrent
    var limitingDate: Date {
        return self.showTodayOnly ? Date(timeIntervalSince1970: 1726808400) : .distantPast
    }
    
    var body: some View {
        NavigationSplitView {
            FeedsView(limitingDate: self.limitingDate)
//            VStack {
//                List {
//                    ForEach(items) { item in
//                        NavigationLink {
//                            VStack {
//                                Text("\(item.timestamp, format: Date.FormatStyle(date: .complete, time: .standard))")
//                                    .font(.headline)
//                                FeedLabel(qtys: item.qty_ml)
//                                SourceLabel(source: item.source)
//                            }
//                            .padding()
//                        } label: {
//                            HStack {
//                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                                FeedLabel(qtys: item.qty_ml)
//                                SourceLabel(source: item.source)
//                            }
//                        }
//                    }
//                    .onDelete(perform: deleteItems)
//                }
//                TotalView(qty_ml: total(items: self.items))
//            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 250, ideal: 300)
            .foregroundStyle(.green)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .foregroundStyle(.green)
                }
#endif
                ToolbarItem {
                    Button {
                        self.showAddItemSheet.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .foregroundStyle(.green)
                }
                ToolbarItem {
                    Button {
                        showTodayOnly.toggle()
                    } label: {
                        Image(systemName: showTodayOnly ? "calendar.badge.checkmark" : "line.3.horizontal.decrease")
                    }
                }
                ToolbarItem {
                    Button {
                        self.importItems()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                
                ToolbarItem {
                    Button {
                        self.deleteAllItems()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .sheet(isPresented: $showAddItemSheet) {
                AddFeedSheetView()
                    .presentationDetents([.medium])
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            .navigationTitle("Feeds")
        } detail: {
            FeedDetailView(items: self.items)
        }
        .foregroundStyle(.green)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Feed.self, inMemory: true)
}

extension ContentView {
    
//    private mutating func filterByToday() {
//        _items = Query(filter: #Predicate<Item> { item in
//            item.timestamp >= limitingDate
//        })
//    }
    
//    private func total(items: [Item]) -> Int {
//        items.map { item in
//            Int(item.qty_ml.rawValue)!
//        }.reduce(0, +)
//    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

extension ContentView {
    
    // TEST DATA
    private func importItems() {
        let historyData = [
            Feed(timestamp: Date(timeIntervalSince1970: 1725166800),
                 qty_ml: .five,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1725253200),
                 qty_ml: .ten,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1725339600),
                 qty_ml: .fifteen,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1725426000),
                 qty_ml: .twenty,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1725512400),
                 qty_ml: .twentyfive,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1725598800),
                 qty_ml: .thirty,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1725685200),
                 qty_ml: .thirtyfive,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1725771600),
                 qty_ml: .forty,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1725858000),
                 qty_ml: .fortyfive,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1725944400),
                 qty_ml: .fifty,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1726030800),
                 qty_ml: .fiftyfive,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1726117200),
                 qty_ml: .sixty,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1726203600),
                 qty_ml: .sixtyfive,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1726290000),
                 qty_ml: .seventy,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1726376400),
                 qty_ml: .seventyfive,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1726462800),
                 qty_ml: .eighty,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1726549200),
                 qty_ml: .eightyfive,
                 source: .formula_enriched),
            Feed(timestamp: Date(timeIntervalSince1970: 1726635600),
                 qty_ml: .ninety,
                 source: .formula_standard),
            Feed(timestamp: Date(timeIntervalSince1970: 1726722000),
                 qty_ml: .ninetyfive,
                 source: .breast),
            Feed(timestamp: Date(timeIntervalSince1970: 1726808400),
                 qty_ml: .onehundred,
                 source: .formula_standard)
            ]
        
        withAnimation {
            for item in historyData {
                modelContext.insert(item)
            }
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            for index in self.items.indices {
                modelContext.delete(items[index])
            }
        }
    }
}

