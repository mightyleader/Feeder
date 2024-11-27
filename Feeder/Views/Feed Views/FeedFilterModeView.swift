//
//  FeedFilterModeView.swift
//  Feeder
//
//  Created by Rob Stearn on 27/11/2024.
//

import SwiftUI

struct FeedFilterModeView: View {
    @Binding var filterMode: FeederDateFilter
    var body: some View {
        HStack {
            Text(self.textFrom(filterMode: self.filterMode))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
    }
    
    private func textFrom(filterMode: FeederDateFilter) -> String {
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
            return "Showing feeds for a single date"
        case .dateRange:
            return "Showing feeds for a date range"
        }
    }
}
