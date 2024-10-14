//
//  FeedsView.swift
//  Feeder
//
//  Created by Rob Stearn on 12/10/2024.
//

import SwiftUI
import SwiftData



struct FeedsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    init(limitingDate: Date) {
        _items = Query(filter: #Predicate<Item> { item in
            item.timestamp >= limitingDate
        }, sort: \Item.timestamp)      
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            TotalView(qty_ml: total())
        }
    }
    
    private func total() -> Int {
        items.map { item in
            item.milk_ml
        }.reduce(0, +)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
