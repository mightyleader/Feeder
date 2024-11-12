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
    WeightView()
}
