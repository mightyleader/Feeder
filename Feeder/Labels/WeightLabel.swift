//
//  WeightLabel.swift
//  Feeder
//
//  Created by Rob Stearn on 10/11/2024.
//

import SwiftUI

struct WeightLabel: View {
    var weight: Double
    
    init(weight: Double) {
        self.weight = weight
    }
    
    var body: some View {
        Text(" \(String(self.weight))g ")
            .background(.orange)
            .foregroundStyle(.white)
            .cornerRadius(5.0)
            .font(.callout)
            .fontWeight(.heavy)
    }
}

#Preview {
                WeightLabel(weight: 3400.00)
}
