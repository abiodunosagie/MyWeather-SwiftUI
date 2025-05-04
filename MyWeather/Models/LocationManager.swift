//
//  LocationManager.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var cityName = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        isLoading = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        lookUpCurrentLocation { [weak self] placemark in
            guard let self = self else { return }
            if let placemark = placemark {
                self.cityName = placemark.locality ?? placemark.name ?? "Unknown Location"
            }
            self.isLoading = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        self.isLoading = false
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        guard let location = self.location else {
            completionHandler(nil)
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                completionHandler(nil)
                return
            }
            
            completionHandler(placemarks?.first)
        }
    }
}
