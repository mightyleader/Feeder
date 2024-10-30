//
//  Note.swift
//  Feeder
//
//  Created by Rob Stearn on 26/10/2024.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    var id: UUID = UUID()
    var title: String
    var date = Date()
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
