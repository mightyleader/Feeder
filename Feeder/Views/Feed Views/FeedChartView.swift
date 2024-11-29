//
//  StastsSheetView.swift
//  Feeder
//
//  Created by Rob Stearn on 23/10/2024.
//

import SwiftUI
import Charts
import SwiftData

struct SourceStat: Identifiable {
    var id: UUID = UUID()
    var source: Source
    var feeds: [Feed]
    var total_qty = 0
    
    
    init(source: Source, feeds: [Feed]) {
        self.source = source
        self.feeds = feeds
        self.total_qty = feeds.reduce(0) {
            $0 + $1.qty_as_int
        }
    }
}

struct FeedChartView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var feeds: [Feed]
    @State private var shouldShowAverage: Bool = true
    
    //Rendering and sharing
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale

    var avg_feed: Double {
        if !feeds.isEmpty {
            return Double(feeds.reduce(0) {
                $0 + $1.qty_as_int
            } / feeds.count)
        }
        return 0
    }
    
    init(limitingDateRange: ClosedRange<Date>) {
        _feeds = Query(filter: #Predicate<Feed> { feed in
            feed.timestamp >= limitingDateRange.lowerBound && feed.timestamp <= limitingDateRange.upperBound
        }, sort: \Feed.timestamp)
    }
    
    var body: some View {
        VStack {
            HStack {
//                ShareLink("Share", item: renderedImage, preview: SharePreview(Text("Shared image"), image: renderedImage))
                Spacer()
                Button {
                    self.dismiss()
                } label: {
                    Label("", systemImage: "xmark")
                }
            }
            Chart  {
                ForEach(splitBySource(feeds: feeds)) { sourceStat in
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
                if (shouldShowAverage == true) {
                    RuleMark(y: .value("Avg. Feed Size", self.avg_feed))
                        .foregroundStyle(.gray)
                        .annotation(position: .top, alignment: .leading) {
                            Text("Avg. \(Int(self.avg_feed))ml")
                                .font(.system(size: 9.0))
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                        }
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
            HStack {
                Toggle(isOn: $shouldShowAverage) {
                    Text("Show average feed size")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }
        }
        .onAppear() {
//            render()
        }
        .padding()
    }
}

extension FeedChartView {
    
    @MainActor private func render() {
        let renderer = ImageRenderer(content: self.body)
        renderer.scale = displayScale
#if os(iOS)
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
#endif
    }
    
    private func splitBySource(feeds: [Feed]) -> [SourceStat] {
        
        let breastFeeds = feeds.filter { $0.source == .breast }
        let formulaFeeds = feeds.filter { $0.source == .formula_standard }
        let enrichedFeeds = feeds.filter { $0.source == .formula_enriched }
        
        var sources: [SourceStat] = []
        if breastFeeds.count > 0 {
            sources.append(SourceStat(source: .breast, feeds: breastFeeds))
        }
        if formulaFeeds.count > 0 {
            sources.append(SourceStat(source: .formula_standard, feeds: formulaFeeds))
        }
        if enrichedFeeds.count > 0 {
            sources.append(SourceStat(source: .formula_enriched, feeds: enrichedFeeds))
        }
        
        return sources
    }
}
