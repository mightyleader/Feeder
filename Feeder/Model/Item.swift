//
//  Item.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import Foundation
import SwiftData

enum Source: String, Codable, CaseIterable, Identifiable {
    case formula_standard = "Formula"
    case formula_enriched = "Formula Enriched"
    case breast = "Breast Milk"
    var id: Self { self }
}

enum Quantities: String, Codable, CaseIterable, Identifiable {
    case zero = "0", five = "5", ten = "10", fifteen = "15", twenty = "20", twentyfive = "25", thirty = "30", thirtyfive = "35", forty = "40", fifty = "50", fiftyfive = "55", sixty = "60", sixtyfive = "65", seventy = "70", seventyfive = "75", eighty = "80", eightyfive = "85", ninety = "90", ninetyfive = "95", onehundred = "100"
    var id: Self { self }
}

@Model
final class Item {
    var timestamp: Date
    var qty_ml : Quantities
    var source: Source
    
    init(timestamp: Date, qty_ml: Quantities, source: Source) {
        self.timestamp = timestamp
        self.source = source
        self.qty_ml = qty_ml
    }
    
    func isToday() -> Bool {
        self.timestamp.distance(to: Date.now) <= 86400
    }
}
