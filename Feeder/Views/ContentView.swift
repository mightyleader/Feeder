//
//  ContentView.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

//    @State private var showNoteSheet: Bool = false
    
    
    var body: some View {
        TabView {
            FeedNavView()
                .tabItem {
                    Label("Feeds", systemImage: "drop")
                }
                .tag(1)
            
            Text("Second View")
                .tabItem {
                    Label("Weight", systemImage: "scalemass")
                }
                .tag(2)
            
            NotesSheetView()
                .tabItem {
                    Label("Notes", systemImage: "pencil.and.list.clipboard")
                }
                .tag(3)
        }
        .tint(.green)
        
//                        ToolbarItem(placement: .secondaryAction) {
//                            Button {
//                                self.deleteAllItems()
//                            } label: {
//                                Label("Delete All Data", systemImage: "trash")
//                            }
//                        }
                        
//                        ToolbarItem(placement: .secondaryAction) {
//                            Button {
//                                showNoteSheet = true
//                            } label: {
//                                Label("Notes",
//                                      systemImage: "pencil.and.list.clipboard")
//                            }
//                        }

//                    .sheet(isPresented: $showNoteSheet) {
//                        NotesSheetView()
//                            .presentationDetents([.large])
//                    }
   
    }
}


