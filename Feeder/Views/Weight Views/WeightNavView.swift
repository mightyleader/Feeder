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
    
    //File importing...
    @State private var text = ""
    @State private var error: Error?
    @State private var isImporting = false
    @State private var isExporting = false
    
    @Query(sort: \Weight.date, order: .forward) private var weights: [Weight]
    
    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    ForEach(weights) { weight in
                        WeightCell()
                    }
                    .onDelete(perform: deleteWeights)
#if os(macOS)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .foregroundStyle(.green)
#endif
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                self.showAddItemSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
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
                    }
                    .sheet(isPresented: $showAddItemSheet) {
                        //                    AddFeedSheetView()
                        //                        .presentationDetents([.large])
                    }
                    .alert("Error importing data", isPresented: $showImportError) {
                        //config
                        // TODO: alert sheet
                    }
                    .alert("Error exporting data", isPresented: $showExportError, actions: {
                        //config
                        // TODO: alert sheet
                    })
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
            }
        } detail: {
            
        }
    }
}

extension WeightNavView {
    func deleteWeights(offsets: IndexSet) {
        //        modelContext.delete(offsets.map(\.self))
    }
}

#Preview {
    WeightNavView()
}
