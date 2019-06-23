//
//  ViewController.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/21/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var updateCoordinateButton: UIButton!
    @IBOutlet weak var checkForWeatherButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var latitude: String = ""
    private var longitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCoordinateButton.alpha = 0.5
        updateCoordinateButton.isEnabled = false
        checkForWeatherButton.alpha = 0.5
        checkForWeatherButton.isEnabled = false
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    
    
    @IBAction func updateCoordinates(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func checkForWeather(_ sender: UIButton) {
        checkForWeatherButton.alpha = 0.5
        checkForWeatherButton.isEnabled = false
        
        Networking.getCurrentWeather(latitude, longitude: longitude) { (item, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let item = item {
                var dataArray: [WeatherItem] = []
                dataArray = DataManager.getCurrentArray()
                
                dataArray.append(item)
                DataManager.writeToUserDefaults(items: dataArray)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
                    vc?.item = item
                    self.present(vc!, animated: true, completion: nil)
                }
            }
            DispatchQueue.main.async {
                self.checkForWeatherButton.alpha = 1
                self.checkForWeatherButton.isEnabled = true                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateCoordinateButton.alpha = 0.5
        updateCoordinateButton.isEnabled = false
        
        guard let location = locations.first else { return }
        
        getAddress(forLocation: location) { (placemark, error) in
            if let error = error {
                print(error)
            } else if let placemark = placemark {
                let country = placemark.country ?? ""
                let locality = placemark.locality ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                
                self.addressLabel.text = "Address: \(country), \(locality), \(thoroughfare)"
            }
        }
        latitude = "\(location.coordinate.latitude)"
        longitude = "\(location.coordinate.longitude)"
        coordinateLabel.text = "Coordinate: \(location.coordinate.latitude) \n \(location.coordinate.longitude)"
        self.updateCoordinateButton.alpha = 1
        self.updateCoordinateButton.isEnabled = true
        
        self.checkForWeatherButton.alpha = 1
        self.checkForWeatherButton.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    private func getAddress(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
    }
}

