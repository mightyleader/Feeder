//
//  FeedDatePickerView.swift
//  Feeder
//
//  Created by Rob Stearn on 20/11/2024.
//

import SwiftUI

struct FeedDatePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.calendar) var calendar
    @State var date: Date = .now
    @Binding var dateRange: ClosedRange<Date>
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.date = .now
                } label: {
                    Label("Today", systemImage: "pin.circle.fill")
                }
                Spacer()
                Button {
                    self.dismiss()
                } label: {
                    Label("", systemImage: "xmark")
                }
            }
        }
        .padding()
        .tint(.green)
        DatePicker(
                "Feed Date",
                selection: $date,
                displayedComponents: [.date]
            )
        .datePickerStyle(.graphical)
        .tint(.green)
        .onChange(of: date, initial: false) { oldValue, newValue in
            dateRange = calendar.startOfDay(for: newValue)...calendar.startOfDay(for: newValue).advanced(by: 86399)
            self.dismiss()
        }
    }
}
