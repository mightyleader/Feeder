//
//  WeightChartView.swift
//  Feeder
//
//  Created by Rob Stearn on 10/11/2024.
//

import SwiftUI
import SwiftData
import Charts

struct WeightChartView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var weights: [Weight]
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                self.dismiss()
            } label: {
                Label("", systemImage: "xmark")
            }
        }
        .padding()
        Chart {
            ForEach(weights) { weight in
                LineMark(x: .value("Date", weight.date),
                        y: .value("Weight in grams", weight.weight))
                .annotation(position: .top) {
                    Text("\(String(weight.weight))g")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 10.0))
                        .fontWeight(.semibold)
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 6)
        .chartLegend(alignment: .top, spacing: 10){
            Text("Weight history")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .scaledToFit()
        .chartYAxisLabel {
            Text("Weight in grams")
        }
        .chartXAxisLabel(alignment: .center) {
            Text("Weights from \(weights.first?.date.formatted(.dateTime) ?? "")-\(weights.last?.date.formatted(.dateTime) ?? "")")
        }
        .padding()
        .chartXAxis {
            AxisMarks {
                AxisValueLabel {}
            }
        }
    }
}

#Preview {
    WeightChartView()
}
