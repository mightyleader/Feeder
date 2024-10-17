//
//  TotalView.swift
//  Feeder
//
//  Created by Rob Stearn on 13/10/2024.
//

import SwiftUI

struct TotalView: View {
    var qty_ml: Int = 0
    var body: some View {
        HStack {
            Text("🍼")
                .font(.largeTitle)
                .padding()
            Text("Total:")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()
            Text("\(qty_ml) ml")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(qty_ml >= 500 ? .green : .red)
                .padding()
        }
    }
}

#Preview {
    TotalView()
}
