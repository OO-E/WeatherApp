//
//  CacheManager.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//


import UIKit

class CacheHelper: NSObject {
    
    fileprivate static let SavedIDs = "UserDefaultsSavedCity"
    
    static func save(city: String?) {
        guard let city = city else {
            return
        }
        var savedIDs = CacheHelper.getSavedIDs()
        savedIDs.append(city)
        let userDefaults = UserDefaults.standard
        userDefaults.set(savedIDs, forKey: SavedIDs)
    }
    
    static func remove(city: String?) {
        guard let city = city else {
            return
        }
        var savedIDs = CacheHelper.getSavedIDs()
        guard let findIndex = savedIDs.firstIndex(of: city) else { return  }
        savedIDs.remove(at: findIndex)
        let userDefaults = UserDefaults.standard
        userDefaults.set(savedIDs, forKey: SavedIDs)
    }
    
    static func getSavedIDs() -> [String] {
        return UserDefaults.standard.object(forKey: SavedIDs) as? [String] ?? []
    }
    
    static func find(city: String?) -> Bool {
        guard let city = city else {
            return false
        }
        let savedIDs = CacheHelper.getSavedIDs()
        return savedIDs.contains(city)
    }
    
}
