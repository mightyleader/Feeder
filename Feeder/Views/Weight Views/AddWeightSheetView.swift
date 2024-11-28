//
//  AddWeightSheetView.swift
//  Feeder
//
//  Created by Rob Stearn on 10/11/2024.
//

import SwiftUI
import SwiftData

struct AddWeightSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @State var weight: String = "0.0"
    @State var type: WeightType = .weight
    @State var date: Date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (alignment: .center) {
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
                    "Weighing Date",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            .datePickerStyle(.graphical)
            .tint(.green)
            
            HStack {
                Spacer()
                TextField("Weight", text: $weight)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.title)
                    .fontWeight(.heavy)
                    .tint(.green)
                    .border(.secondary)
                    .textFieldStyle(.roundedBorder)
                    .frame(alignment: .center)
                Text(" grams")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            
//            HStack {
//                Picker("Type", selection: $type) {
//                    ForEach(WeightType.allCases) { type in
//                        Text(type.rawValue)
//                    }
//                }
//                .pickerStyle(InlinePickerStyle())
//                .tint(.green)
//                .font(.headline)
//                .fontWeight(.heavy)
//            }
            
            Button("Add Weight") {
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
            let newItem = Weight(weight: Double(weight) ?? 0.0, type: type, date: date)
            modelContext.insert(newItem)
            self.dismiss()
        }
    }
}

#Preview {
    AddWeightSheetView(type: .birthWeight)
}
