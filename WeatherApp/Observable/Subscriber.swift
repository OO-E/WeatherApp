//
//  Subscriber.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation


func observerAbstractMethod(file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    observerFatalError("Abstract method", file: file, line: line)
}

func observerFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never  {
    fatalError(lastMessage(), file: file, line: line)
}

class SubscriberBase<Element> {
    func on(_ event: Element) {
        observerAbstractMethod()
    }
}

final class AnonymousSubscriber<Element>: SubscriberBase<Element> {
    typealias EventHandler = (Element?) -> Void
    
    private let _eventHandler : EventHandler
    
    init(_ eventHandler: @escaping EventHandler) {
        self._eventHandler = eventHandler
    }

    override func on(_ event: Element?) {
         return self._eventHandler(event)
    }

    
}
