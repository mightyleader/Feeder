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
    private var filterMode: FeederDateFilter
    
    init(qty_ml: Int, highlightTarget: Bool, filterMode: FeederDateFilter) {
        self.highlightTarget = highlightTarget
        self.filterMode = filterMode
        self.qty_ml = qty_ml
    }
    
    var body: some View {
        VStack {
            if filterMode == .today || filterMode == .singleDate {
                Text("Daily target is \(Int(feedTarget ?? 500)) ml")
                    .font(.footnote)
                    .tint(.gray)
                    .fontWeight(.semibold)
            }
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
}

#Preview {
    TotalView(qty_ml: 100, highlightTarget: true, filterMode: .allTime)
}
