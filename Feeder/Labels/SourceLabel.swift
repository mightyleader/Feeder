//
//  SourceLabel.swift
//  Feeder
//
//  Created by Rob Stearn on 17/10/2024.
//

import SwiftUI

struct SourceLabel: View {
    
    var source: Source
    var color: Color = .pink
    
    init(source: Source) {
        self.source = source
        switch source {
        case .breast:
            self.color = .pink
        case .formula_enriched:
            self.color = .red
        case .formula_standard:
            self.color = .orange
        }
    }
    
    var body: some View {
        Text(" \(self.source.rawValue) ")
            .background(self.color)
            .foregroundStyle(.white)
            .cornerRadius(5.0)
            .font(.caption)
            .fontWeight(.heavy)
            .padding(EdgeInsets(top: 2.0, leading:  3.0, bottom:  2.0, trailing: 3.0))
    }
}

#Preview {
    SourceLabel(source: .breast)
}
