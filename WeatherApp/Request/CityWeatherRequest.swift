//
//  CityWeatherRequest.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation
import Networking

class CityWeatherRequest: Request,Codable {

    var cityName: String
    
    var path: String {
        return "weather?q=\(cityName)&appid=e118d6594e814fd370e1833e0e5e09a3&units=Metric"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    
    init(cityName: String) {
        self.cityName = cityName
    }
}


struct CityWeatherResponse: Codable {
    
    let coord: Coord
    let weather: [Weather]?
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String
    let cod: Int?
    
    func getCelsius() ->  String {
        return String(self.main.temp)
    }
    func getWeatherImageUrl() -> String {
        if let icon = self.weather?.first?.icon {
            return "https://openweathermap.org/img/w/\(icon).png"
        } else {
            return ""
        }
        
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

struct  Wind: Codable {
    let speed: Double?
    let deg: Double?
}
// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
