//
//  WeightView.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import SwiftUI
import SwiftData

struct WeightView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Weight.date, order: .forward) private var weights: [Weight]
    
    private var showTodayOnly: Bool
    private var filterMode: FeederDateFilter
    
    init(dateQueryRange: ClosedRange<Date>, filterMode: FeederDateFilter) {
        self.filterMode = filterMode
        self.showTodayOnly = false
        _weights = Query(filter: #Predicate<Weight> { weight in
            weight.date >= dateQueryRange.lowerBound && weight.date <= dateQueryRange.upperBound
        }, sort: \Weight.date)
    }
    
    var body: some View {
        List {
            ForEach(self.weights) { weight in
                NavigationLink {
                    EditWeightView(weight: weight)
                } label: {
                    WeightCell(weight: weight)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func total(items: [Weight]) -> Double {
        items.map { item in
            item.weight
        }.reduce(0, +)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(weights[index])
            }
        }
    }
}

#Preview {
    WeightView(dateQueryRange: Date.distantPast...Date.distantFuture, filterMode: .allTime)
}
