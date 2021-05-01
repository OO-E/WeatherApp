//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func download(url: String?) {
        if let _url = url {
            self.kf.setImage(with: URL(string: _url))
        } else {
            self.image = UIImage(named: "placeholder")
        }
        
    }
}
