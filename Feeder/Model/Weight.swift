//
//  Weight.swift
//  Feeder
//
//  Created by Rob Stearn on 09/11/2024.
//

import Foundation
import SwiftData

enum WeightType: String, Codable, CaseIterable {
    case weight
    case birthWeight
}

@Model
final class Weight: Identifiable {
    var id = UUID()
    var weight: Double
    var date: Date
    var type: WeightType = WeightType.weight
    
    init(weight: Double, date: Date) {
        self.weight = weight
        self.date = date
    }
}
