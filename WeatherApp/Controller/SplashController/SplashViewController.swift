//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit

class SplashViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func configure() {
        
        
        let vc = MainController.createFromStoryboard()
        vc.viewModel = MainViewModel()
        let navigation = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.rootViewController = navigation

    }
}
