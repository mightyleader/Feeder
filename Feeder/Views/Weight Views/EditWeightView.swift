//
//  EditWeightView.swift
//  Feeder
//
//  Created by Rob Stearn on 10/11/2024.
//

import SwiftUI

struct EditWeightView: View {
    @Environment(\.modelContext) private var modelContext
    @State var weight: Weight
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            DatePicker(
                    "Weighing Date",
                    selection: $weight.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            .datePickerStyle(.graphical)
            .tint(.green)
            
            HStack {
                Spacer()
                TextField("Weight", value: $weight.weight, formatter: numberFormatter)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.title)
                    .fontWeight(.heavy)
                    .tint(.green)
                Text(" grams")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            
            HStack {
                Spacer()
                Picker("Type", selection: $weight.type) {
                    ForEach(WeightType.allCases) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .tint(.green)
                .font(.headline)
                .fontWeight(.heavy)
                Spacer()
            }
            
            Button("Edit Weight") {
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
    EditWeightView(weight: Weight(weight: 3000.00,
                                  type: .weight,
                                  date: Date()))
}
