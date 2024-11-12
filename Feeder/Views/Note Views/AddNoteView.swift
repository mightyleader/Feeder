//
//  AddNoteView.swift
//  Feeder
//
//  Created by Rob Stearn on 04/11/2024.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var notebody: String = "Type your note here..."
    @State private var contentErrorFound: Bool = false
    
    var body: some View {
        VStack {
            TextField("Add title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .cornerRadius(10.0)
            TextEditor(text: $notebody)
                .textEditorStyle(.automatic)
                .autocapitalization(.none)
                .backgroundStyle(.gray)
                .cornerRadius(10.0)
                .padding()
            Button("Add Note") {
                self.addNote()
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
    
    
    private func addNote() {
        if title.isEmpty {
            self.contentErrorFound = true
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let note = Note(title: self.title, body: self.notebody)
        self.modelContext.insert(note)
        self.dismiss()
    }
}

#Preview {
    AddNoteView()
}
