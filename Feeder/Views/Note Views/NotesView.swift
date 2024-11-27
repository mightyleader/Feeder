//
//  NotesView.swift
//  Feeder
//
//  Created by Rob Stearn on 26/10/2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @State private var showAddNote: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationSplitView {
            VStack {
                //LIST
                List {
                    ForEach(notes) { note in
                        NavigationLink {
                            NoteDetailView(note: note)
                        } label: {
                            Text(note.title)
                        }
                    }
                    .onDelete(perform: deleteNotes)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showAddNote.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .tint(.green)
                }
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        self.dismiss()
//                    } label: {
//                        Label("Close", systemImage: "xmark")
//                    }
//                    .tint(.green)
//                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView()
                    .presentationDetents([.large])
            }
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            .navigationTitle("Notes")
//            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            //TODO: Detail view for the larger devices.
        }
        
    }
}

extension NotesView {
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    NotesView()
}
