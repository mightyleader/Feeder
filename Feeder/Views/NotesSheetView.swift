//
//  NotesView.swift
//  Feeder
//
//  Created by Rob Stearn on 26/10/2024.
//

import SwiftUI
import SwiftData

struct NotesSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    Button {
                        self.initialNote()
                    } label: {
                        Label("", systemImage: "plus")
                    }
                    Spacer()
                    Button {
                        self.dismiss()
                    } label: {
                        Label("", systemImage: "xmark")
                    }
                }
                .padding()
                
                //LIST
                List {
                    ForEach(notes) { note in
                        NavigationLink {
                            
                        } label: {
                            Text(note.title)
                        }
                    }
                    NavigationLink {
                        
                    } label: {
                        Text("Add a Note...")
                    }
                }
                
                //INPUT
                VStack {
                    TextField("Title", text: .constant("Type something here..."))
                    
                }
            }.padding()
        } detail: {
            
        }
        
    }
}

extension NotesSheetView {
    private func initialNote() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let note = Note(title: dateFormatter.string(from: Date.now), body: "Test Note. Who doesn't love a test note.")
        self.modelContext.insert(note)
    }
}

#Preview {
    NotesSheetView()
}
