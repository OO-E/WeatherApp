//
//  Loader.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit

class Loader {
    static var backgroundView: UIView!
    static var activityIndicatorView: UIActivityIndicatorView!
    
    class func initializeLoader(){
        backgroundView = UIView.init()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        backgroundView.isUserInteractionEnabled = true
        
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.tintColor = UIColor(white: 0.5, alpha: 1)
        activityIndicatorView.startAnimating()
    }
    
    class func show(){
        self.dismiss()
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first!
            if !self.backgroundView.isDescendant(of: window) {
                window .addSubview(self.backgroundView)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[background]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["background":self.backgroundView]))
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[background]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["background":self.backgroundView]))
            }
            if !self.activityIndicatorView.isDescendant(of: window) {
                window.addSubview(self.activityIndicatorView)
                self.activityIndicatorView.center = window.center
            }
        }
    }
    
    class func dismiss(){
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first!
            if self.backgroundView.isDescendant(of: window) {
                self.backgroundView.removeFromSuperview()
            }
            if self.activityIndicatorView.isDescendant(of: window) {
                self.activityIndicatorView.removeFromSuperview()
            }
        }
    }
    
}
