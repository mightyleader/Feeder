//
//  AddFeedSheetView.swift
//  Feeder
//
//  Created by Rob Stearn on 16/10/2024.
//

import SwiftUI
import SwiftData

struct AddFeedSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @State var qty: Int = 0
    @State var source: Source = .formula_standard
    @State var date: Date = Date()
    
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
            
            DatePicker(
                    "Feed Date",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            .datePickerStyle(.graphical)
            .tint(.green)
            
            HStack {
                Spacer()
//                Picker("Feed", selection: $qty) {
//                    ForEach(Quantities.allCases) { qty in
//                        Text("\(qty.rawValue) ml")
//                    }
//                }
                Picker("Feed", selection: $qty) {
                    ForEach(0..<2000) { qty in
                        Text("\(qty) ml")
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
                Picker("Source", selection: $source) {
                    ForEach(Source.allCases) { source in
                        Text(source.rawValue)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .tint(.green)
                .font(.headline)
                .fontWeight(.heavy)
                Spacer()
            }
            
            Button("Add Feed") {
                self.addItem()
            }
            .font(.headline)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.green)
            Spacer()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Feed(timestamp: date, qty_as_int:qty, source: source)
            modelContext.insert(newItem)
            self.dismiss()
        }
    }
}

#Preview {
    AddFeedSheetView()
}
