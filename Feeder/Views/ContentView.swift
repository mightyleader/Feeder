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
    @State private var showStatSheet: Bool = false
    
    @Query(sort: \Feed.timestamp, order: .forward) private var feeds: [Feed]
    
    var calendar: Calendar = .autoupdatingCurrent
    var limitingDate: Date {
        return self.showTodayOnly ? Calendar.autoupdatingCurrent.startOfDay(for:Date.now) : .distantPast
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                FeedsView(limitingDate: self.limitingDate, showTodayOnly: self.showTodayOnly)
#if os(macOS)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .foregroundStyle(.green)
#endif
                    .toolbar {
#if os(iOS)
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.showStatSheet.toggle()
                            } label: {
                                Label("Details", systemImage: "chart.pie.fill")
                            }
                            .tint(.green)
                        }
#endif
                        ToolbarItem {
                            Button {
                                self.showAddItemSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
                            }
                            .tint(.green)
                        }
                        ToolbarItem {
                            Button {
                                showTodayOnly.toggle()
                            } label: {
                                Text(showTodayOnly ? "Show All" : "Show Today")
                            }
                        }
//                        ToolbarItem {
//                            Button {
//                                self.deleteAllItems()
//                            } label: {
//                                Image(systemName: "trash")
//                            }
//                        }
                    }
                    .sheet(isPresented: $showAddItemSheet) {
                        AddFeedSheetView()
                            .presentationDetents([.large])
                    }
                    .sheet(isPresented: $showStatSheet, content: {
                        StatsSheetView(limitingDate: self.limitingDate)
                            .presentationDetents([.large])
                    })
#if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
#endif
                    .navigationTitle("Feeds")
            }
        } detail: {
#if os(macOS)
            FeedDetailView()
#endif
#if os(iOS)
            
#endif
        }
        .foregroundStyle(.green)
        .tint(.green)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Feed.self, inMemory: true)
}

extension ContentView {
    
    private func deleteAllItems() {
        withAnimation {
            for index in self.feeds.indices {
                modelContext.delete(feeds[index])
            }
        }
    }
}

