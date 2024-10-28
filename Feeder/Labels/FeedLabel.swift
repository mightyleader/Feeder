//
//  FeedLabel.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct FeedLabel: View {
    
    var qtys: Quantities
    var qty: Int
    
    init(qtys: Quantities) {
        self.qtys = qtys
        self.qty = 0
    }
    
    init (qty: Int) {
        self.qty = qty
        self.qtys = .zero
    }
    
    var body: some View {
        Text(" \(String(self.qty)) ml ") //s.rawValue
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(5.0)
            .fontWeight(.heavy)
    }
}

#Preview {
    FeedLabel(qtys: .fifty)
}
