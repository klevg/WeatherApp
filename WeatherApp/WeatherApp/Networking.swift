//
//  Networking.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/21/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import Foundation

class Networking {
    
//    let secreKey = "5d0106d8902e6abeae66ac29f95999d5"
//    let api = "https://api.darksky.net/forecast/5d0106d8902e6abeae66ac29f95999d5/"
    static func getCurrentWeather(_ latitude: String, longitude: String, completion: @escaping (WeatherItem?, Error?) -> Void ) {
        
        let url = URL(string: "https://api.darksky.net/forecast/5d0106d8902e6abeae66ac29f95999d5/\(latitude),\(longitude)")!
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error!.localizedDescription)
                    completion(nil,error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                    if let responseKeyJson = jsonResponse?["currently"] as? [String: Any], let timezone = jsonResponse?["timezone"] as? String {
//                        var weatherItem = WeatherItem()
                        let time = responseKeyJson["time"] as! Int
                        let summary = responseKeyJson["summary"] as! String
                        let precipIntensity = responseKeyJson["precipIntensity"] as! Int
                        let precipProbability = responseKeyJson["precipProbability"] as! Int
                        let temperature = responseKeyJson["temperature"] as! NSNumber
                        let apparentTemperature = responseKeyJson["apparentTemperature"] as! NSNumber
                        let dewPoint = responseKeyJson["dewPoint"] as! NSNumber
                        let humidity = responseKeyJson["humidity"] as! NSNumber
                        let pressure = responseKeyJson["pressure"] as! NSNumber
                        let windSpeed = responseKeyJson["windSpeed"] as! NSNumber
                        let visibility = responseKeyJson["visibility"] as! NSNumber

                        let item = WeatherItem(timezone: timezone, time: time, summary: summary, precipIntensity: precipIntensity, precipProbability: precipProbability, temperature: Int(truncating: temperature), apparentTemperature: Int(truncating: apparentTemperature), dewPoint: Int(truncating: dewPoint), humidity: Int(truncating: humidity), pressure: Int(truncating: pressure), windSpeed: Int(truncating: windSpeed), visibility: Int(truncating: visibility))
                        
                        completion(item, nil)
                    }
                }catch let error {
                    print ("Ops not good JSON formatted response")
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
