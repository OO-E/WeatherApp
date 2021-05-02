//
//  BaseViewModel.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    func transform(input: Input)
}

class BaseViewModel {
    
    var errorState = Observable<ErrorState>()
    var loaderState = Observable<LoaderState>()
    
}

enum ErrorState {
    
    case showWith(title: String, message: String)
    case networkError
    case logout
    case none
}

enum LoaderState {
    case show
    case dismiss
}
