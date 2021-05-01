//
//  CitySearchController.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit

class CitySearchController: BaseViewController {
    
    @IBOutlet weak var cityWeatherImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    var viewModel: CitySearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavigationColor()
    }
    
    func configure() {
        
        self.title = "Search"
        submitButtonUpdate()
        self.rightNavigationItems(items: [.dismiss])
        self.setViewModel(viewModel: viewModel)
        
        self.viewModel.locationInfo.subscribe { (info) in
            self.submitButtonUpdate()
            guard let _info = info else {
                self.infoLabel.isHidden = true
                self.submitButton.isHidden = true
                self.cityWeatherImage.isHidden = true
                return
            }
            self.cityWeatherImage.isHidden = false
            self.submitButton.isHidden = false
            self.infoLabel.isHidden = false
            self.cityWeatherImage.download(url: self.viewModel.cityResponse.getWeatherImageUrl())
            self.infoLabel.text = _info
            
        }
        
        
        self.textField.delegate = self
    }
    
    func changeNavigationColor() {
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "SearchNavigationColor")

        // Navigation Bar Text:
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor.init(named: "SearchNavigationColor")
        tabBarController?.tabBar.tintColor = UIColor.white
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if let city = viewModel.cityResponse.name.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) {
            if !CacheHelper.find(city: city) {
                CacheHelper.save(city: city)
            } else {
                CacheHelper.remove(city: city)
            }
            submitButtonUpdate()
        }
    }
    
    func submitButtonUpdate() {
        guard let response = viewModel.cityResponse else {
            return
        }
        if let city = response.name.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) {
            if !CacheHelper.find(city: city) {
                submitButton.backgroundColor = UIColor(named: "AddColor")
                submitButton.setTitle("Add City", for: .normal)

            } else {
                submitButton.backgroundColor = UIColor(named: "RemoveColor")
                submitButton.setTitle("Remove City", for: .normal)
            }
        }
    }
    
}


extension CitySearchController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        mainThread {
            self.viewModel.searchCity(cityName: textField.text ?? "")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
