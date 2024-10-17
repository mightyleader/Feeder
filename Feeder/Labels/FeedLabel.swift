//
//  FeedLabel.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct FeedLabel: View {
    
    var qtys: Quantities
    
    init(qtys: Quantities) {
        self.qtys = qtys
    }
    
    var body: some View {
        Text(" \(String(self.qtys.rawValue)) ml ")
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(5.0)
            .fontWeight(.heavy)
    }
}

#Preview {
    FeedLabel(qtys: .fifty)
}
