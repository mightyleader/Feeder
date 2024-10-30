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
        VStack {
            HStack {
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
                    Text(note.title)
                }
            }
            
            //INPUT
            VStack {
                TextField("", text: .constant(""))
                    
            }
        }
    }
}

#Preview {
    NotesSheetView()
}
