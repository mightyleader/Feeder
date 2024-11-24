//
//  Item.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import Foundation
import SwiftData

@Model
final class Feed {
    var timestamp: Date = Date.now
    var qty_ml : Quantities = Quantities.zero
    var source: Source = Source.breast
    var qty_as_int: Int = 0
//    { Int(qty_ml.rawValue) ?? 0 }
    var id = UUID()
    
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
