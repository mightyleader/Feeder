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
            
            WeightNavView()
                .tabItem {
                    Label("Weight", systemImage: "scalemass")
                }
                .tag(2)
            
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "pencil.and.list.clipboard")
                }
                .tag(3)
        }
        .tint(.green)
    }
}


