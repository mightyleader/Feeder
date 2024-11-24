//
//  Weight.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import Foundation
import SwiftData

@Model
final class Weight: Identifiable {
    var id = UUID()
    var weight: Double
    var date: Date = Date()
    var type: WeightType = WeightType.weight
    
    init(weight: Double,
         type: WeightType) {
        self.weight = weight
        self.type = type
    }
    
    init(weight: Double,
         type: WeightType,
         date: Date) {
        self.weight = weight
        self.type = type
        self.date = date
    }
}
