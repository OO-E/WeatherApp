//
//  BaseRouter.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit


class BaseRouter {
    
    var push = Observable<UIViewController>()
    var present = Observable<UIViewController>()
    
    
    
    func searchCity() {
        let controller = CitySearchController.createFromStoryboard()
        controller.viewModel = CitySearchViewModel()
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        self.present.value = navigation
    }
    
}
