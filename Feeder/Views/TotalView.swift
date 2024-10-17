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
                .font(.title)
                .padding()
            Text("Total:")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.gray)
                .padding()
            Text("\(qty_ml) ml")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(qty_ml >= 500 ? .green : .red)
                .padding()
        }
    }
}

#Preview {
    TotalView()
}
