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

@Model
final class Item {
    var timestamp: Date
    var qty_ml = 0 as Int
    var source: Source
    
    init(timestamp: Date, qty_ml: Int, source: Source) {
        self.timestamp = timestamp
        self.source = source
        self.qty_ml = qty_ml
    }
    
    func isToday() -> Bool {
        self.timestamp.distance(to: Date.now) <= 86400
    }
}
