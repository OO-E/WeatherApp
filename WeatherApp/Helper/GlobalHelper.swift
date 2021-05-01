//
//  GlobalHelper.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import Foundation

func mainThread(main: @escaping () -> ()) {
    DispatchQueue.main.async(execute: {
        main()
    })
}


func mainThread(withDelay seconds: Double = 0.0, main: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        DispatchQueue.main.async(execute: {
            main()
        })
    }
}

func backgroundThread(delay: Double = 0.0, background: @escaping (() -> Void), main: @escaping (() -> Void)) {
    DispatchQueue.global().async {
        background()
        mainThread(withDelay: delay, main: {
            main()
        })
    }
}
