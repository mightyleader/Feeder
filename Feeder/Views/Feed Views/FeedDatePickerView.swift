//
//  FeedDatePickerView.swift
//  Feeder
//
//  Created by Rob Stearn on 20/11/2024.
//

import SwiftUI

struct FeedDatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var date: Date
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.dismiss()
                } label: {
                    Label("Cancel", image: "xmark")
                }
                Spacer()
                Button {
                    self.date = .now
                } label: {
                    Label("Today", image: "pin.circle.fill")
                }
            }
            .padding()
        }
        DatePicker(
                "Feed Date",
                selection: $date,
                displayedComponents: [.date]
            )
        .datePickerStyle(.graphical)
        .tint(.green)
        .onChange(of: date, initial: false) { oldValue, newValue in
            self.dismiss()
        }
    }
}

//#Preview {
//    FeedDatePickerView()
//}
