//
//  FeederEnums.swift
//  Feeder
//
//  Created by Rob Stearn on 20/11/2024.
//

import Foundation

public enum FeederDateFilter {
    case today
    case last7days
    case last30days
    case singleDate
    case dateRange
    case allTime
}

enum WeightType: String, Codable, CaseIterable, Identifiable, Equatable{
    case weight = "Standard Weighing"
    case birthWeight = "Birth Weight"
    var id: Self { self }
}

enum Source: String, Codable, CaseIterable, Identifiable, Equatable {
    case formula_standard = "Formula"
    case formula_enriched = "Formula Enriched"
    case breast = "Breast Milk"
    var id: Self { self }
}

enum Quantities: String, Codable, CaseIterable, Identifiable {
    case zero = "0", five = "5", ten = "10", fifteen = "15", twenty = "20", twentyfive = "25", thirty = "30", thirtyfive = "35", forty = "40", fortyfive = "45", fifty = "50", fiftyfive = "55", sixty = "60", sixtyfive = "65", seventy = "70", seventyfive = "75", eighty = "80", eightyfive = "85", ninety = "90", ninetyfive = "95", onehundred = "100"
    var id: Self { self }
}
