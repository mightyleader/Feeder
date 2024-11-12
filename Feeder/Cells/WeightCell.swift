//
//  WeightCell.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import SwiftUI

struct WeightCell: View {
    var weight: Weight
    
    init(weight: Weight) {
        self.weight = weight
    }
    
    var body: some View {
        HStack {
            Text("\(weight.date, format: Date.FormatStyle(date: .complete,  time: .standard))").foregroundStyle(.gray)
            Spacer()
            WeightLabel(weight: weight.weight)
            weight.type == .birthWeight ? Image(systemName: "birthday.cake") : Image(systemName: "scalemass.fill")
            
        }
    }
}

#Preview {
    WeightCell(weight: .init(weight: 100,
                             type: .birthWeight))
}
