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
    
    //File importing...
    @State private var text = ""
    @State private var error: Error?
    @State private var isImporting = false
    @State private var isExporting = false
    
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
                                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                                   return
                                }
                                if UIApplication.shared.canOpenURL(url) {
                                   UIApplication.shared.open(url, options: [:])
                                }
                            } label: {
                                Label("Settings", systemImage: "gear")
                            }
                            .tint(.green)
                        }
#endif
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.showStatSheet.toggle()
                            } label: {
                                Label("Details", systemImage: "chart.pie.fill")
                            }
                            .tint(.green)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isImporting = true
                            } label: {
                                Label("Import Data",
                                      systemImage: "square.and.arrow.down")
                            }
                        }
                        
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button {
//                                isExporting = true
//                            } label: {
//                                Label("Share Data",
//                                      systemImage: "square.and.arrow.up")
//                            }
//                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            let url = self.exportAllItems()
                            ShareLink(item: url!)
                        }
                    
                        ToolbarItem {
                            Button {
                                self.showAddItemSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
                            }
                            .tint(.green)
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showTodayOnly.toggle()
                            } label: {
                                Text(showTodayOnly ? "Show All" : "Show Today")
                            }
                        }
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
                    .fileImporter(isPresented: $isImporting, allowedContentTypes: [.text, .commaSeparatedText]) { result in
                        //
                    }
                    
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

extension ContentView { //DATA MANAGEMENT
    
    private func deleteAllItems() {
        withAnimation {
            for index in self.feeds.indices {
                modelContext.delete(feeds[index])
            }
        }
    }
    
    private func exportAllItems() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = url.appendingPathComponent("Feeder Data-\(Date.now.description).csv")
        do {
            var stringOfFeeds: String = ""
            for feed in feeds {
                stringOfFeeds.append("\(feed.id), \(feed.timestamp), \(feed.timestamp), \(feed.qty_as_int), \(feed.source.rawValue)\n")
            }
            if let dataOfFeeds = stringOfFeeds.data(using: .utf8) {
                if dataOfFeeds.count > 0
                    /*&& !FileManager.default.fileExists(atPath: fileURL.path)*/ {
                    try dataOfFeeds.write(to: fileURL)
                    return fileURL
                }
            }
        } catch {
            print("Error exporting: \(error)")
        }
        return nil
    }
}

