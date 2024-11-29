//
//  WeightFilterModeView.swift
//  Feeder
//
//  Created by Rob Stearn on 29/11/2024.
//

import SwiftUI

struct WeightFilterModeView: View {
    @Binding var filterMode: FeederDateFilter
    @Binding var limitingDateRange: ClosedRange<Date>
    var dateFormat: Date.FormatStyle = Date.FormatStyle(date: .abbreviated)
    var body: some View {
        HStack {
            Text(self.textFrom(filterMode: self.filterMode,
                               forDateRange: self.limitingDateRange))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
    }
    
    private func textFrom(filterMode: FeederDateFilter,
                          forDateRange dateRange: ClosedRange<Date>) -> String {
        switch filterMode {
        case .today:
            return "Showing weights for today"
        case .allTime:
            return "Showing all weights"
        case .last7days:
            return "Showing weights for the last 7 days"
        case .last30days:
            return "Showing weights for the last 30 days"
        case .singleDate:
            return "Showing weights for \(dateRange.lowerBound.formatted(dateFormat))"
        case .dateRange:
            return "Showing weights for dates between \(dateRange.lowerBound.formatted(dateFormat)) and \(dateRange.upperBound.formatted(dateFormat))"
        }
    }
}
