//
//  DataManager.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/23/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import Foundation

class DataManager {
    static func getCurrentArray() -> [WeatherItem] {
        var dataArray: [WeatherItem] = []
        if let recovedUserArrayData = UserDefaults.standard.object(forKey: "dataArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([WeatherItem].self, from: recovedUserArrayData) {
                    dataArray = loadedItems
            }
        }
        return dataArray
    }
    
    static func writeToUserDefaults(items: [WeatherItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "dataArray")
        }
    }    
}
