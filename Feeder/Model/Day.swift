//
//  Day.swift
//  Feeder
//
//  Created by Rob Stearn on 19/10/2024.
//

import Foundation
import SwiftData

@Model
final class Day {
    var date: Date
    var day: Date
    
    init(date: Date, day: Date) {
        self.date = date
        self.day = day
    }
}
