//
//  EditFeedSheetView.swift
//  Feeder
//
//  Created by Rob Stearn on 22/10/2024.
//

import SwiftUI

struct EditFeedSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @State var feed: Feed
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            DatePicker(
                    "Feed Date",
                    selection: $feed.timestamp,
                    displayedComponents: [.date, .hourAndMinute]
                )
            .datePickerStyle(.graphical)
            .tint(.green)
            
            HStack {
                Spacer()
                Picker("Feed", selection: $feed.qty_ml) {
                    ForEach(Quantities.allCases) { qty in
                        Text("\(qty.rawValue) ml")
                    }
                }
#if os(macOS)
                .pickerStyle(MenuPickerStyle())
#endif
#if os(iOS)
                .pickerStyle(WheelPickerStyle())
                .font(.headline)
                .fontWeight(.heavy)
                .tint(.green)
#endif
                Spacer()
            }
            
            HStack {
                Spacer()
                Picker("Source", selection: $feed.source) {
                    ForEach(Source.allCases) { source in
                        Text(source.rawValue)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .font(.headline)
                .fontWeight(.heavy)
                .tint(.green)
                Spacer()
            }
            
            Button("Edit Feed") {
                self.save()
            }
            .font(.headline)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.green)
            Spacer()
        }
    }
    
    private func save() {
        try? self.modelContext.save()
        self.dismiss()
    }
}

#Preview {
    EditFeedSheetView(feed: Feed(timestamp: Date.now,
                                 qty_ml: .fifty,
                                 source: .breast))
}
