//
//  NoteDetailView.swift
//  Feeder
//
//  Created by Rob Stearn on 04/11/2024.
//

import SwiftUI

struct NoteDetailView: View {
    var note: Note
    var body: some View {
        VStack{
            Text(note.title)
                .font(.title)
                .foregroundStyle(.primary)
                .padding()
            Text(note.date.formatted(.dateTime))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding()
            ScrollView{
                Text(note.body)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding()
                Spacer()
            }
        }
        .frame(alignment: .leading)
        .padding()
        
    }
}

#Preview {
    NoteDetailView(note: Note(title: "Test note", body: "Here is a test note."))
}
