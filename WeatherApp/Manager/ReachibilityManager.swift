//
//  ReachibilityManager.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//


import UIKit
import Reachability

class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()
    static  var observer = [BaseViewController]()
    private var showAlert = false
    private var alert: UIAlertController?
    private var presentedController: UIViewController?
    
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .unavailable
    }
    
    var reachabilityStatus: Reachability.Connection = .unavailable
    let reachability = try! Reachability()
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            reachability.whenUnreachable = { reachability in
                mainThread {
                    guard
                        let visibleViewController = UIApplication.shared.visibleViewController
                        else { return }
                    if !self.showAlert {
                        self.showAlert = true
                    }
                }
            }
            try reachability.startNotifier()
            
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    func setSubscribe(controller: BaseViewController) {
        ReachabilityManager.observer.append(controller)
    }
    
    func triggerObserver(reachability: Reachability) {
        ReachabilityManager.observer.forEach { (controller) in
            controller.reachabilityChangedStatus(reachibility: reachability)
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        triggerObserver(reachability: reachability)
        guard
            let visibleViewController = UIApplication.shared.visibleViewController
            else { return }
        if self.presentedController == nil {
            self.presentedController = visibleViewController
        }
    }
}
