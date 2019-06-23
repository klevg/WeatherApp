//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/22/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import Foundation

struct WeatherItem: Codable {
    let timezone: String
    let time: Int
    let summary: String
    let precipIntensity: Int
    let precipProbability: Int
    let temperature: Int
    let apparentTemperature: Int
    let dewPoint: Int
    let humidity: Int
    let pressure: Int
    let windSpeed: Int
    let visibility: Int
}
