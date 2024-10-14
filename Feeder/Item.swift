//
//  Item.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import Foundation
import SwiftData

enum Source: String, Codable, CaseIterable {
    case formula_standard
    case formula_enriched
    case breast
    case combo
}

@Model
final class Item {
    var timestamp: Date
    var milk_ml = 0 as Int
    var source: Source
    
    init(timestamp: Date, source: Source) {
        self.timestamp = timestamp
        self.source = source
        self.milk_ml = 50  
    }
    
    func isToday() -> Bool {
        self.timestamp.distance(to: Date.now) <= 86400
    }
    
    func isLast24Hours() -> Bool {
        self.timestamp.distance(to: Date.now) <= 86400
    }
}
