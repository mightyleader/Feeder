//
//  FeederDateConstants.swift
//  Feeder
//
//  Created by Rob Stearn on 26/11/2024.
//

import Foundation

let today = Calendar.autoupdatingCurrent.startOfDay(for:Date.now)
let last7days = Calendar.autoupdatingCurrent.startOfDay(for:Date.now).advanced(by: 86400 * -7)
let last30days = Calendar.autoupdatingCurrent.startOfDay(for:Date.now).advanced(by: 86400 * -30)
let allTime = Calendar.autoupdatingCurrent.startOfDay(for:Date.now).advanced(by: 86400 * -356)
