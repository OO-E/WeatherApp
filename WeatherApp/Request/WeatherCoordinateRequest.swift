//
//  WeatherCoordinateRequest.swift
//  WeatherApp
//
//  Created by OO E on 2.05.2021.
//

import Foundation
import Networking

class WeatherCoordinateRequest: Request,Codable {

    var latitude: Double
    var longitude: Double
    
    var path: String {
        return "weather?lat=\(latitude)&lon=\(longitude)&appid=e118d6594e814fd370e1833e0e5e09a3&units=Metric"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    
    init(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
    }
}
