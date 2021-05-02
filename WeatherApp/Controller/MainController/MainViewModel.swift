//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit
import Networking

class MainViewModel: BaseViewModel {
    
    private let locationManager = LocationManager()
    var myCity: String!
    var cityList = Observable<[CityWeatherResponse]>()
    
    override init() {
        super.init()
        
        cityList.value = []
        locationManager.handleAuthorization = { status in
                self.getMyLocation()
        }
    }
    
    func getMyLocation() {
        guard let exposedLocation = self.locationManager.exposedLocation else {
            return
        }
        
        guard let lat = self.locationManager.exposedLocation?.coordinate.latitude else {
            return
        }
        guard let long = self.locationManager.exposedLocation?.coordinate.longitude else {
            return
        }
        fetchMyLocation(lat: lat, long: long)
    }
    
    func getSavedList() {
        cityList.value?.removeAll()
        let cityList = CacheHelper.getSavedIDs()
        
        cityList.forEach { (city) in
            fetchWeather(city: city)
        }
        
    }
    
    func fetchWeather(city: String) {
        if city == "" {
            return
        }
        
        guard let _city = city.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            return
        }
        

        if ReachabilityManager.shared.isNetworkAvailable == false {
            self.errorState.value = .networkError
            return
        }
        
        let request = CityWeatherRequest(cityName: _city)
        RestClient.default.makeRequest(request: request) { (response: CityWeatherResponse?, error: RestClient.Error?) in
            guard let _response = response else {
                return
            }
            if response?.name == self.myCity {
                self.cityList.value?.insert(_response, at: 0)
            } else {
                self.cityList.value?.append(_response)
            }
        }
    }
    
    func fetchMyLocation(lat: Double, long: Double) {
        if ReachabilityManager.shared.isNetworkAvailable == false {
            self.errorState.value = .networkError
            return
        }
        let request = WeatherCoordinateRequest.init(lat: lat, long: long)
        RestClient.default.makeRequest(request: request) { (response:CityWeatherResponse? , error: RestClient.Error?) in
            guard let _response = response else {
                return
            }
            self.cityList.value?.insert(_response, at: 0)
            self.myCity = _response.name
        }
    }
    
    
    
}
