//
//  Observable.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation


class Observable<Element> {
    
    init() {
        
    }
    
    init(value: Element) {
        self.value = value
    }
    var value : Element? {
        didSet {
            subscribers.forEach { (subscriber) in
                subscriber.on(value)
            }
        }
    }

   private var subscribers = [AnonymousSubscriber<Element>]()
    
   func subscribe(_ on: @escaping (Element?) -> Void) {
        let observer = AnonymousSubscriber<Element> { e in
            on(e)
        }
        subscribers.append(observer)
    }
    
}
