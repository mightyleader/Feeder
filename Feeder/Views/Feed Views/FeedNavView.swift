//
//  FeedNavView.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct FeedNavView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showTodayOnly: Bool = true
    @State private var showAddItemSheet: Bool = false
    @State private var showStatSheet: Bool = false
    @State private var showImportError: Bool = false
    @State private var showExportError: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showDateRangePicker: Bool = false
    
    //File importing/exporting...
    @State private var isImporting = false
    @State private var isExporting = false
    
    @Query(sort: \Feed.timestamp, order: .forward) private var feeds: [Feed]
    
    @State var filterMode: FeederDateFilter = .today
    @State var limitingDate: Date = Calendar.autoupdatingCurrent.startOfDay(for:Date.now)
    @State var limitingDateRange: ClosedRange<Date> = allTime...today
    
    var body: some View {
        NavigationSplitView {
            VStack {
                FeedsView(dateQueryRange: self.limitingDateRange, filterMode: self.filterMode)
#if os(macOS)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .foregroundStyle(.green)
#endif
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            Menu {
                                Button("Today",
                                       action: {
                                    self.limitingDateRange = today...today.advanced(by: 86399)
                                    self.filterMode = .today
                                })
                                Button("Last 7 days",
                                       action: {
                                    self.limitingDateRange = last7days...Date.now
                                    self.filterMode = .last7days
                                })
                                Button("Last 30 days",
                                       action: {
                                    self.limitingDateRange = last30days...Date.now
                                    self.filterMode = .last30days
                                })
                                Button("All feeds",
                                       action: {
                                    self.limitingDateRange = allTime...Date.now
                                    self.filterMode = .allTime
                                })
                                Button("Choose a date",
                                       action: {
                                    self.showDatePicker.toggle()
                                    self.filterMode = .singleDate
                                })
                                Button("Choose date range",
                                       action: {
                                    self.showDateRangePicker.toggle()
                                    self.filterMode = .dateRange
                                })
                            } label: {
                                Label("Filter", systemImage: "calendar")
                            }
                            .tint(.green)
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                self.showAddItemSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
                            }
                            .tint(.green)
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                self.showStatSheet.toggle()
                            } label: {
                                Label("Details", systemImage: "chart.pie.fill")
                            }
                            .tint(.green)
                        }
                        
                        ToolbarItem(placement: .secondaryAction) {
                            Button {
                                isImporting = true
                            } label: {
                                Label("Import",
                                      systemImage: "square.and.arrow.down")
                            }
                        }
                        
                        ToolbarItem(placement: .secondaryAction) {
                            if let url = self.exportAllItems() {
                                ShareLink("Export", item: url)
                            }
                        }
#if os(iOS)
                        ToolbarItem(placement: .secondaryAction) {
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
                        
                        ToolbarItem(placement: .secondaryAction) {
                            Button {
                                self.migrationRoutine()
                            } label: {
                                Label("Migrate",
                                      systemImage: "wrench.adjustable")
                            }
                        }
#endif
                    }
                    .sheet(isPresented: $showAddItemSheet) {
                        AddFeedSheetView(date: limitingDate)
                            .presentationDetents([.large])
                    }
                    .sheet(isPresented: $showStatSheet, content: {
                        StatsSheetView(limitingDate: self.limitingDate)
                            .presentationDetents([.large])
                    })
                    .sheet(isPresented: $showDatePicker) {
                        FeedDatePickerView(dateRange: $limitingDateRange)
                            .presentationDetents([.large])
                    }
                    .sheet(isPresented: $showDateRangePicker) {
                        FeedDateRangePickerView(dateQueryRange: $limitingDateRange)
                            .presentationDetents([.medium])
                    }
                
//                    .alert("Error importing data", isPresented: $showImportError) {
//                        //config
//                        // TODO: alert sheet
//                    }
//                    .alert("Error exporting data", isPresented: $showExportError, actions: {
//                        //config
//                        // TODO: alert sheet
//                    })
#if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
#endif
                    .navigationTitle("Feeds")
                    .fileImporter(isPresented: $isImporting,
                                  allowedContentTypes: [.commaSeparatedText]) { result in
                        switch result {
                        case .success(let url):
                            self.importFeeds(from: url)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
            }
        } detail: {
#if os(macOS)
            FeedDetailView()
#endif
        }
        .tint(.green)
    }
}

extension FeedNavView { //DATA MANAGEMENT
    
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
            showExportError.toggle()
        }
        return nil
    }
    
    private func migrationRoutine() {
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
    
    private func importFeeds(from url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            self.showImportError.toggle()
            return
        }
        guard let stringOfFeeds = String(data: data, encoding: .utf8) else {
            self.showImportError.toggle()
            return
        }
        let stringOfStringsOfFeeds = String(stringOfFeeds)
        let arrayOfStrings = (stringOfStringsOfFeeds as String).split(separator: "\n")
        let arrayOfFeeds = arrayOfStrings.map {
            $0.split(separator: ",")
        }
        if arrayOfStrings.count > 0 && arrayOfFeeds[0].count >= 4 {
            let arrayOfFeedObjects = arrayOfFeeds.map {
                Feed(timestamp: self.dateFrom(string: String($0[1])) ?? Date(),
                     qty_as_int: Int(String($0[3]).trimmingCharacters(in: .whitespacesAndNewlines))!, //Need some nil-testing here
                     source: self.sourceFrom(rawValue: String($0[4])))
            }
            for feed in arrayOfFeedObjects {
                self.modelContext.insert(feed)
            }
        }
    }
    
    private func sourceFrom(rawValue: String) -> Source {
        switch rawValue.trimmingCharacters(in: .whitespacesAndNewlines) {
        case "Breast Milk":
            return .breast
        case "Formula":
            return .formula_standard
        case "Formula Enriched":
            return .formula_enriched
        default:
            return .formula_standard
        }
    }
    
    private func dateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if let date = dateFormatter.date(from: string) {
            return date
        }
        return nil
    }
}


