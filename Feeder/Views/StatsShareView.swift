//
//  StatsShareView.swift
//  Feeder
//
//  Created by Rob Stearn on 05/11/2024.
//

import SwiftUI
import Charts

struct StatsShareView: View {
    @State var sourceStats: [SourceStat]
    @State var feeds: [Feed]
    var avg_feed: Double {
        if !feeds.isEmpty {
            return Double(feeds.reduce(0) {
                $0 + $1.qty_as_int
            } / feeds.count)
        }
        return 0
    }
    
    init(sourceStats: [SourceStat], feeds: [Feed]) {
        self.sourceStats = sourceStats
        self.feeds = feeds
    }
    
    var body: some View {
        Chart  {
            ForEach(self.sourceStats) { sourceStat in
                SectorMark(angle: .value("Feed size", sourceStat.total_qty),
                           innerRadius: .ratio(0.6),
                           angularInset: 1.0)
                .annotation(position: .overlay) {
                    Text(String("\(sourceStat.total_qty)ml"))
                            .foregroundStyle(.white)
                    .fontWeight(.semibold)                        }
                    .cornerRadius(10.0)
                    .foregroundStyle(by: .value("Source", sourceStat.source.rawValue))
            }
        }
        .chartLegend(alignment: .center, spacing: 10)
        .scaledToFit()
        .chartBackground { chartProxy in
          GeometryReader { geometry in
            if let anchor = chartProxy.plotFrame {
              let frame = geometry[anchor]
                Text("Feed size by source\nTotal feed \(feeds.reduce(0) { $0 + $1.qty_as_int })ml")
                .multilineTextAlignment(.center)
                .position(x: frame.midX, y: frame.midY)
                .font(.headline)
                .foregroundStyle(.secondary)
            }
          }
        }
        Spacer(minLength: 15.0)
        //bar or line - histogram
        Chart {
            ForEach(feeds) { feed in
                BarMark(x: .value("Date", feed.timestamp.formatted()),
                        y: .value("Feed in ml", feed.qty_as_int))
                .annotation(position: .top) {
                    Text("\(String(feed.qty_as_int))ml")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 10.0))
                        .fontWeight(.semibold)
                }
            }
            RuleMark(y: .value("Avg. Feed Size", self.avg_feed))
                .foregroundStyle(.gray)
                .annotation(position: .top, alignment: .leading) {
                    Text("Avg. \(Int(self.avg_feed))ml")
                        .font(.system(size: 9.0))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 6)
        .chartLegend(alignment: .top, spacing: 10){
            Text("Feed history")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .scaledToFit()
        .chartYAxisLabel {
            Text("Feed in ml")
        }
        .chartXAxisLabel(alignment: .center) {
            Text("Feeds from \(feeds.first?.timestamp.formatted(.dateTime) ?? "")-\(feeds.last?.timestamp.formatted(.dateTime) ?? "")")
        }
        .chartXAxis {
            AxisMarks {
                AxisValueLabel {}
            }
        }
    }
}
//
//#Preview {
//    StatsShareView()
//}
