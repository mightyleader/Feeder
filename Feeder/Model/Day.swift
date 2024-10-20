//
//  Day.swift
//  Feeder
//
//  Created by Rob Stearn on 19/10/2024.
//

import Foundation
import SwiftData

@Model
final class Day: Identifiable, Equatable, Comparable {
    static func < (lhs: Day, rhs: Day) -> Bool {
        if lhs.date == rhs.date {
            return lhs.id < rhs.id
        }
        return lhs.date < rhs.date
    }
    
    var id = UUID()
    var date: Date
    var feeds: [Feed]
    
    init(date: Date, feeds: [Feed]) {
        self.date = date
        self.feeds = feeds
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.date == rhs.date
    }
}
