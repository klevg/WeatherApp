//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/23/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var precipIntensity: UILabel!
    @IBOutlet weak var precipProbability: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var apparentTemperature: UILabel!
    @IBOutlet weak var dewPoint: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var visibility: UILabel!
    
    var item: WeatherItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timezoneLabel.text = "Timezone: \(item.timezone)"
        let  date = Date(timeIntervalSince1970: Double(item.time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.long
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        timeLabel.text = "Date: \(localDate)"
        
        summaryLabel.text = "Summary: \(item.summary)"
        precipIntensity.text = "The intensity (in inches of liquid water per hour) is \(item.precipIntensity) of precipitation occurring at the given time."
        precipProbability.text = "The probability of precipitation occurring is \(item.precipProbability)"
        temperature.text = "Temperature is \(item.temperature)"
        apparentTemperature.text = "The apparent (or “feels like”) temperature is \(item.apparentTemperature) in degrees Fahrenheit"
        dewPoint.text = "The dew point is \(item.dewPoint) in degrees Fahrenheit"
        humidity.text = "Humidity: \(item.humidity)"
        pressure.text = "The sea-level air pressure in millibars is \(item.pressure)"
        windSpeed.text = "The wind gust speed in miles per hour is \(item.windSpeed)"
        visibility.text = "The average visibility in miles is \(item.visibility), capped at 10 miles"
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
