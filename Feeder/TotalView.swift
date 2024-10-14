//
//  TotalView.swift
//  Feeder
//
//  Created by Rob Stearn on 13/10/2024.
//

import SwiftUI

struct TotalView: View {
    var qty_ml: Int = 0
    var body: some View {
        Text("Todays Total: \(qty_ml)ml")
    }
}

#Preview {
    TotalView()
}
