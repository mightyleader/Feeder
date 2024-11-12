//
//  EditNoteView.swift
//  Feeder
//
//  Created by Rob Stearn on 12/11/2024.
//

import SwiftUI
import SwiftData

struct EditNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var note: Note
    @State private var contentErrorFound: Bool = false
    
    init(note: Note) {
        self.note = note
    }
    var body: some View {
        VStack {
            TextField("", text: $note.title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .cornerRadius(10.0)
            TextEditor(text: $note.body)
                .textEditorStyle(.automatic)
                .autocapitalization(.none)
                .backgroundStyle(.gray)
                .cornerRadius(10.0)
                .padding()
            Button("Edit Note") {
                self.editNote()
            }
            .font(.headline)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.green)
            Spacer()
        }
        .alert(isPresented: $contentErrorFound) {
            Alert(title: Text("Error"), message: Text("Please enter a title and note body."))
        }
    }
    
    private func editNote() {
        if note.title.isEmpty {
            self.contentErrorFound = true
            return
        }
        self.note.date = Date()
        try? self.modelContext.save()
        self.dismiss()
    }
}

#Preview {
    EditNoteView(note: Note(title: "I want to remember this", body: "Here's a thing I want to try to remember so I made a note about it and saved it."))
}
