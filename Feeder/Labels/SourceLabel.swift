//
//  SourceLabel.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct SourceLabel: View {
    
    var source: Source
    
    init(source: Source) {
        self.source = source
    }
    
    var body: some View {
        Text(" \(self.source.rawValue) ")
            .background(.pink)
            .foregroundStyle(.white)
            .cornerRadius(5.0)
            .fontWeight(.heavy)
    }
}

#Preview {
    SourceLabel(source: .breast)
}
