//
//  FeedFilterModeView.swift
//  Feeder
//
//  Created by Rob Stearn on 27/11/2024.
//

import SwiftUI

struct FeedFilterModeView: View {
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
            return "Showing feeds for today"
        case .allTime:
            return "Showing all feeds"
        case .last7days:
            return "Showing feeds for the last 7 days"
        case .last30days:
            return "Showing feeds for the last 30 days"
        case .singleDate:
            return "Showing feeds for \(dateRange.lowerBound.formatted(dateFormat))"
        case .dateRange:
            return "Showing feeds for dates between \(dateRange.lowerBound.formatted(dateFormat)) and \(dateRange.upperBound.formatted(dateFormat))"
        }
    }
}
