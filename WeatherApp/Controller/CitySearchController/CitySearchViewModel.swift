//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit
import Networking

class CitySearchViewModel: BaseViewModel {
    
    private var locationManager = LocationManager()
    var locationInfo = Observable<String>()
    var cityResponse: CityWeatherResponse!
    
    private func getLocationWith(lat: Double, Long: Double) {
        
        
        locationManager.getLocationWith(lat: lat, long: Long) { (model) in
            self.locationInfo.value = model.country + " " + self.cityResponse.name + " " + self.cityResponse.getCelsius() + "°"
        }
    }
    
    func searchCity(cityName: String) {
        
        if ReachabilityManager.shared.isNetworkAvailable == false {
            self.errorState.value = .networkError
            return
        }
        
        if let city = cityName.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) {
            self.loaderState.value = .show
            let request = CityWeatherRequest(cityName: city)
            RestClient.default.makeRequest(request: request) { (response: CityWeatherResponse?, error: RestClient.Error?) in
                self.loaderState.value = .dismiss
                guard let _response = response else {
                    self.locationInfo.value = nil
                    self.errorState.value = .showWith(title: "", message: "Please search another city !!")
                    return
                }
                
                if let _ = error {
                    self.errorState.value = ErrorState.showWith(title: "", message: error.debugDescription)
                    return
                }
                
                let lat = _response.coord.lat
                let long = _response.coord.lon
                self.cityResponse = _response
                self.getLocationWith(lat: lat, Long: long)
                
            }
        }
       
    }
    
}
