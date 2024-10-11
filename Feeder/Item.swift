//
//  Item.swift
//  Feeder
//
//  Created by Rob Stearn on 11/10/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
