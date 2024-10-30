//
//  Item.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import Foundation
import SwiftData

enum Source: String, Codable, CaseIterable, Identifiable, Equatable {
    case formula_standard = "Formula"
    case formula_enriched = "Formula Enriched"
    case breast = "Breast Milk"
    var id: Self { self }
}

enum Quantities: String, Codable, CaseIterable, Identifiable {
    case zero = "0", five = "5", ten = "10", fifteen = "15", twenty = "20", twentyfive = "25", thirty = "30", thirtyfive = "35", forty = "40", fortyfive = "45", fifty = "50", fiftyfive = "55", sixty = "60", sixtyfive = "65", seventy = "70", seventyfive = "75", eighty = "80", eightyfive = "85", ninety = "90", ninetyfive = "95", onehundred = "100"
    var id: Self { self }
}

@Model
<<<<<<< HEAD:Feeder/Model/Item.swift
final class Item {
    var timestamp: Date = Date.now
    var qty_ml : Quantities = Quantities.zero
    var source: Source = Source.breast
    var qty_as_int: Int { Int(qty_ml.rawValue) ?? 0 }
=======
final class Feed {
    var timestamp: Date = Date.now
    var qty_ml : Quantities = Quantities.zero
    var source: Source = Source.breast
    var qty_as_int: Int = 0
//    { Int(qty_ml.rawValue) ?? 0 }
    var id = UUID()
>>>>>>> sandbox:Feeder/Model/Feed.swift
    
    init(timestamp: Date, qty_ml: Quantities, source: Source) {
        self.timestamp = timestamp
        self.source = source
        self.qty_ml = qty_ml
    }
    
    init(timestamp: Date, qty_as_int: Int, source: Source) {
        self.timestamp = timestamp
        self.source = source
        self.qty_as_int = qty_as_int
    }
}
