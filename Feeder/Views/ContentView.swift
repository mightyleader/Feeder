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
                                Label("Import...",
                                      systemImage: "square.and.arrow.down")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.migrationRoutine()
                            } label: {
                                Label("Migrate",
                                      systemImage: "wrench.adjustable")
                            }
                        }
                        
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
                stringOfFeeds.append("\(feed.id), \(feed.timestamp), \(feed.qty_ml.rawValue), \(feed.qty_as_int), \(feed.source.rawValue)\n")
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
    
    private func migrationRoutine() {
        for feed in feeds {
            //Read from UserDefaults.
            let defaults = UserDefaults.standard
            let migrationComplete = defaults.bool(forKey: "migrationComplete")
            print("Migration status: \(migrationComplete)")
            
            if migrationComplete == false {
                for feed in self.feeds {
                    //enum is non-zero and qty is 0 - Copy enum.rawvalue to qty
                    if feed.qty_ml != .zero && feed.qty_as_int == 0 {
                        print("Feed enum is \(feed.qty_ml), Feed Int is \(feed.qty_as_int). MIGRATING")
                        if let intFromString = Int(feed.qty_ml.rawValue) {
                            feed.qty_as_int = intFromString
                        }
                    } else {
                        //enum is zero and qty is 0 - DO NOTHING
                        //enum is zero and qty is > 0 - DO NOTHING
                        //enum is non-zero and qty is > 0 - DO NOTHING
                        print("Feed enum is \(feed.qty_ml), Feed Int is \(feed.qty_as_int). NOT MIGRATING")
                    }
                }
                do {
                    try? self.modelContext.save()
                    print("Migration saved to persistent store.")
                    defaults.set(true, forKey: "migrationComplete")
                    print ("Migration status saved to UserDefaults.")
                }
            } else {
                return
            }
        }
    }
}

