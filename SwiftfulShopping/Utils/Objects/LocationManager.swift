//
//  LocationManager.swift
//  SwiftlyShopping
//
//  Created by Łukasz Janiszewski on 04/04/2022.
//

import Foundation
import MapKit
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @Published var locationCoordinates: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getAddressDataFromLocation(completion: @escaping (([String: String]) -> ())) {
        if let locationCoordinates = locationCoordinates {
            let latitude = locationCoordinates.latitude
            let longitude = locationCoordinates.longitude
            let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            let ceo: CLGeocoder = CLGeocoder()

            var addressData: [String: String] = [String: String]()
            
            let group = DispatchGroup()
            group.enter()
            
            ceo.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("reverse geodcode fail: \(error.localizedDescription)")
                    group.leave()
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        DispatchQueue.main.async {
                            if let city = placemark.locality {
                                addressData["city"] = city
                            }
                            
                            if let streetName = placemark.thoroughfare {
                                addressData["streetName"] = streetName
                            }
                            
                            if let streetNumber = placemark.subThoroughfare {
                                addressData["streetNumber"] = streetNumber
                            }
                            
                            if let zipCode = placemark.postalCode {
                                addressData["zipCode"] = zipCode
                            }
                            
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(addressData)
            }
        }
        
        completion([String: String]())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCoordinates = locations.first?.coordinate
    }
}
