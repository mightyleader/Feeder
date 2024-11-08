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
    var date: Date
    
    init(weight: Double, date: Date) {
        self.weight = weight
        self.date = date
    }
}
