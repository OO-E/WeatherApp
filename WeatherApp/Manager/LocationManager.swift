//
//  LocationManager.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation
import CoreLocation


class LocationManager: NSObject  {
    
    
    private let locationManager = CLLocationManager()
    
    var handleAuthorization: ((_ status: CLAuthorizationStatus) -> ())?
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
   
}


// MARK: - Core Location Delegate
extension LocationManager: CLLocationManagerDelegate {
    
  
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        handleAuthorization?(status)
        switch status {
        
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        }
    }
}

extension LocationManager {
    
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    
    func getLocationWith(lat: Double, long: Double, complation: @escaping (_ model: LocationModel) -> () ) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            
            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            
            let country = placeMark.addressDictionary!["Country"] as? String
            let city = placeMark.addressDictionary!["City"] as? String
                
            complation(LocationModel(city: city ?? "", country:  country ?? ""))
        })
    }
}

struct LocationModel {
    let city: String
    let country: String
}
