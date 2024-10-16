//
//  AddFeedSheetView.swift
//  Feeder
//
//  Created by Rob Stearn on 16/10/2024.
//

import SwiftUI
import SwiftData

enum qtys: Int, CaseIterable, Identifiable {
    case zero = 0, five = 5, ten = 10, fifteen = 15, twenty = 20, twentyfive = 25, thirty = 30, thirtyfive = 35, forty = 40, fifty = 50, fiftyfive = 55, sixty = 60, sixtyfive = 65, seventy = 70, seventyfive = 75, eighty = 80, eightyfive = 85, ninety = 90, ninetyfive = 95, onehundred = 100
    var id: Self { self }
}

//enum sources: String, CaseIterable, Identifiable {
//    case breastmilk = "Breast Milk",
//         formula = "Formula",
//         formula_enriched = "Formula Enriched"
//    var id: Self { self }
//}

struct AddFeedSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @State var qty: qtys = .zero
    @State var source: Source = .formula_standard
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Picker("Feed", selection: $qty) {
                ForEach(qtys.allCases) { qty in
                    Text("\(qty.rawValue) ml")
                }
            }
#if os(macOS)
            .pickerStyle(MenuPickerStyle())
            .padding()
#endif
#if os(iOS)
            .pickerStyle(WheelPickerStyle())
            .font(.title)
            .fontWeight(.heavy)
            .padding()
#endif
            Picker("Source", selection: $source) {
                ForEach(Source.allCases) { source in
                    Text(source.rawValue)
                }
            }
            .pickerStyle(InlinePickerStyle())
            
            Button("Add Feed") {
                self.addItem()
            }
            .font(.largeTitle)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .backgroundStyle(.green)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date(), qty_ml:qty.rawValue, source: source)
            modelContext.insert(newItem)
            self.dismiss()
        }
    }
}

#Preview {
    AddFeedSheetView()
}
