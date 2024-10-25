//
//  TotalView.swift
//  Feeder
//
//  Created by Rob Stearn on 13/10/2024.
//

import SwiftUI

struct TotalView: View {
    @AppStorage("feedTarget") private var feedTarget: Double?
    var qty_ml: Int = 0
    var highlightTarget: Bool

    
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
                .foregroundColor(highlightTarget ? ( qty_ml >= /*self.dailyFeedTarget*/ Int(feedTarget ?? 500) ? .green : .red) : .primary)
                .padding()
        }
    }
}

#Preview {
    TotalView(highlightTarget: true)
}
