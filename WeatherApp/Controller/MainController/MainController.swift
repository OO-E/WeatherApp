//
//  MainController.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit

class MainController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavigationColor()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getMyLocation()
    }
    
    func configure() {
        self.title = "Weather App"
        self.setViewModel(viewModel: viewModel)
        self.rightNavigationItems(items: [.search])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        
        
        viewModel.cityList.subscribe { (list) in
            self.tableView.reloadData()
        }
        
    }
   
    
    override func didTapSearch(sender: AnyObject) {
        self.router.searchCity()
    }
    
    func changeNavigationColor() {
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "MainNavigationColor")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor.init(named: "MainNavigationColor")
        tabBarController?.tabBar.tintColor = UIColor.white
    }
    
    func removeItem(index: IndexPath) {
        
        let cityResponse = viewModel.cityList.value![index.row]
        let message = "Do you want to delete this city " + cityResponse.name + " ?"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            CacheHelper.remove(city: cityResponse.name)
            self.viewModel.cityList.value?.remove(at: index.row)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        if let item = viewModel.cityList.value?[indexPath.row] {
            if viewModel.myCity == item.name {
                cell.myLocationLabel.isHidden = false
            } else {
                cell.myLocationLabel.isHidden = true
            }
            cell.weatherImage.download(url: item.getWeatherImageUrl())
            cell.weatherLabel.text = item.name + " " + item.getCelsius() + "°"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.cityList.value![indexPath.row]
        if viewModel.myCity == item.name {
            
        } else {
            removeItem(index: indexPath)
        }
        
    }
    
}

