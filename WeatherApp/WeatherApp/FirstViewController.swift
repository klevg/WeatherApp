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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
    }
    
    
    @IBAction func updateCoordinates(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func checkForWeather(_ sender: UIButton) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        
        coordinateLabel.text = "Coordinate: \(location.coordinate.latitude) \n \(location.coordinate.longitude)"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func getAddress(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
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

