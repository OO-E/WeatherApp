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
            
            if status == .authorizedWhenInUse || status == .authorizedWhenInUse {
                self.cityList.value?.removeAll()
                self.getMyLocation()
            }
            
        }
    }
    
    func getMyLocation() {
        cityList.value?.removeAll()
        guard let exposedLocation = self.locationManager.exposedLocation else {
            getSavedList()
            return
        }
        
        self.locationManager.getPlace(for: exposedLocation) { [self] (placeMark) in
            
        
            guard let placeMark = placeMark else  {return}
            
            if let town = placeMark.locality {
                self.myCity = town
                self.fetchWeather(city: town)
                getSavedList()
            }
            
        }
    }
    
    func getSavedList() {
        
        let cityList = CacheHelper.getSavedIDs()
        
        cityList.forEach { (city) in
            fetchWeather(city: city)
        }
        
    }
    
    func fetchWeather(city: String) {
        let request = CityWeatherRequest(cityName: city)
        RestClient.default.makeRequest(request: request) { (response: CityWeatherResponse?, error: RestClient.Error?) in
            guard let _response = response else {
                return
            }
            
            self.cityList.value?.append(_response)
        }
    }
    
}
