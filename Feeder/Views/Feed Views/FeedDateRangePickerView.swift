//
//  FeedDateRangePickerView.swift
//  Feeder
//
//  Created by Rob Stearn on 25/11/2024.
//

import SwiftUI

struct FeedDateRangePickerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.calendar) var calendar
    @State var fromDate: Date = Calendar.autoupdatingCurrent.startOfDay(for: .now).advanced(by: 86400 * -10)
    @State var toDate: Date = .now
    @Binding var dateQueryRange: ClosedRange<Date>

    var body: some View {
        VStack {
            HStack {
                Button {
                    self.toDate = .now
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
            DatePicker("From",
                       selection: $fromDate,
                       displayedComponents: [.date])
            .datePickerStyle(.automatic)
            DatePicker("From",
                       selection: $toDate,
                       displayedComponents: [.date])
            .datePickerStyle(.automatic)
            Button("Choose dates") {
                self.dateQueryRange = self.fromDate...calendar.startOfDay(for: self.toDate).advanced(by: 86399)
                self.dismiss()
            }
            .font(.headline)
            .fontWeight(.heavy)
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(.green)
            Spacer()
        }
        .padding()
        .tint(.green)
    }
}
