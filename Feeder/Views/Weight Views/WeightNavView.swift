//
//  WeightView.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import SwiftUI
import SwiftData

struct WeightNavView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddItemSheet: Bool = false
    @State private var showStatSheet: Bool = false
    @State private var showImportError: Bool = false
    @State private var showExportError: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showDateRangePicker: Bool = false
    
    //File importing...
    @State private var text = ""
    @State private var error: Error?
    @State private var isImporting = false
    @State private var isExporting = false
    
    @State var filterMode: FeederDateFilter = .allTime
    @State var limitingDateRange: ClosedRange<Date> = allTime...today
    
    @Query private var weights: [Weight]
    
    var body: some View {
        NavigationSplitView {
            VStack {
                WeightFilterModeView(filterMode: $filterMode, limitingDateRange: $limitingDateRange)
                WeightView(dateQueryRange: self.limitingDateRange, filterMode: self.filterMode)
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
                                Button("All weights",
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
                            if let url = self.exportAllWeights() {
                                ShareLink("Export", item: url)
                            }
                        }
                    }
                    .sheet(isPresented: $showAddItemSheet) {
                        AddWeightSheetView().presentationDetents([.large])
                    }
                    .sheet(isPresented: $showStatSheet, content: {
                        WeightChartView()
                            .presentationDetents([.medium])
                    })
                    .sheet(isPresented: $showDatePicker) {
                        DatePickerView(dateRange: $limitingDateRange)
                          .presentationDetents([.fraction(0.65)])
                    }
                    .sheet(isPresented: $showDateRangePicker) {
                        DateRangePickerView(dateQueryRange: $limitingDateRange)
                           .presentationDetents([.fraction(0.25)])
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
                    .navigationTitle("Weight")
                    .fileImporter(isPresented: $isImporting,
                                  allowedContentTypes: [.commaSeparatedText]) { result in
                        switch result {
                        case .success(let url):
                            self.importWeights(from: url)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
        } detail: {
            
        }
        .foregroundStyle(.green)
        .tint(.green)
    }
}

extension WeightNavView {
    func deleteWeights(offsets: IndexSet) {
//                modelContext.delete(offsets.map(\.self))
    }
    
    private func exportAllWeights() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = url.appendingPathComponent("Feeder Weight Data-\(Date.now.description).csv")
        do {
            var stringOfWeights: String = ""
            for weight in weights {
                stringOfWeights.append("\(weight.id), \(weight.date), \(weight.weight), \(weight.type)\n")
            }
            if let dataOfWeights = stringOfWeights.data(using: .utf8) {
                if dataOfWeights.count > 0 {
                    try dataOfWeights.write(to: fileURL)
                    return fileURL
                }
            }
        } catch {
            print("Error exporting: \(error)")
            showExportError.toggle()
        }
        return nil
    }
    
    private func importWeights(from url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            self.showImportError.toggle()
            return
        }
        guard let stringOfWeights = String(data: data, encoding: .utf8) else {
            self.showImportError.toggle()
            return
        }
        let stringOfStringsOfWeights = String(stringOfWeights)
        let arrayOfStrings = (stringOfStringsOfWeights as String).split(separator: "\n")
        let arrayOfWeights = arrayOfStrings.map {
            $0.split(separator: ",")
        }
        if arrayOfStrings.count > 0 && arrayOfWeights[0].count >= 4 {
            let arrayOfWeightObjects = arrayOfWeights.map {
                Weight(weight: Double($0[2]) ?? 0.0,
                       type: self.typeFrom(String:String($0[3])) ?? .weight,
                       date: self.dateFrom(string:String($0[1])) ?? Date())
            }
            for feed in arrayOfWeightObjects {
                self.modelContext.insert(feed)
            }
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
    
    private func typeFrom(String string: String) -> WeightType? {
        if string.lowercased() == "birthWeight" {
            return .birthWeight
        }
        return .weight
    }
}

#Preview {
    WeightNavView()
}
