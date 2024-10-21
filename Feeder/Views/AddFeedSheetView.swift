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
    @State var qty: Quantities = .zero
    @State var source: Source = .formula_standard
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Picker("Feed", selection: $qty) {
                ForEach(Quantities.allCases) { qty in
                    Text("\(qty.rawValue) ml")
                }
            }
#if os(macOS)
            .pickerStyle(MenuPickerStyle())
//            .padding()
#endif
#if os(iOS)
            .pickerStyle(WheelPickerStyle())
            .font(.title)
            .fontWeight(.heavy)
//            .padding()
#endif
            Picker("Source", selection: $source) {
                ForEach(Source.allCases) { source in
                    Text(source.rawValue)
                }
            }
            .pickerStyle(InlinePickerStyle())
            
            Button("Add Feed") {
                print("1. Add Button tapped")
                self.addItem()
            }
            .font(.largeTitle)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .backgroundStyle(.green)
            Spacer()
        }
    }
    
    private func addItem() {
        print("2. Add Item function called")
        withAnimation {
            let newItem = Feed(timestamp: Date(), qty_ml:qty, source: source)
            modelContext.insert(newItem)
            self.dismiss()
        }
    }
}

#Preview {
    AddFeedSheetView()
}
