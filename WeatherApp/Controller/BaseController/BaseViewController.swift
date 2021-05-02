//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit
import Reachability

class BaseViewController: UIViewController {
    
    var router = BaseRouter()
    private var viewModel: BaseViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRouter()
        ReachabilityManager.shared.setSubscribe(controller: self)
        
    }
    
    private func configureRouter() {
        
        router.push.subscribe { (controller) in
            
            guard let _controller = controller else {
                return
            }
            self.navigationController?.pushViewController(_controller, animated: true)
            
        }
        
        router.present.subscribe { (controller) in
            
            guard let _controller = controller else {
                return
            }
            self.present(_controller, animated: true, completion: nil)
        }
        
    }
    
    func setViewModel(viewModel: BaseViewModel) {
        self.viewModel = viewModel
       
        self.viewModel.loaderState.subscribe { (loader) in
            guard let _loader = loader else {
                return
            }
            switch _loader {
            case .show:
                self.showLoader()
                break
            case .dismiss:
                self.dismissLoader()
                break
            }
            
        }
        
        self.viewModel.errorState.subscribe { (error) in
            guard let _error = error else {
                return
            }
            
            switch _error {
            case .showWith(let title, let message):
                self.showMessageWith(title: title, message: message)
                break
            case .logout:
                //TODO --
                break
            case .networkError:
                self.showMessageWith(title: "", message: "You don't have any network connection. Please check your connection.")
            case .none:
                break
            }
        }
        
    }
    
    func leftnavigationItems(items:[NavigationItem]){
        var leftNavigationElements:[UIBarButtonItem] = []
        for item in items {
            leftNavigationElements.append(self.navigationItems(item: item)!)
        }
        
        navigationItem.leftBarButtonItems = leftNavigationElements
    }
    
    func rightNavigationItems(items:[NavigationItem]){
        
        var rightNavigationElements:[UIBarButtonItem] = []
        for item in items {
            rightNavigationElements.append(self.navigationItems(item: item)!)
        }
        navigationItem.rightBarButtonItems = rightNavigationElements
    }
    
    private func navigationItems(item:NavigationItem) -> UIBarButtonItem?{
        switch item {
        case .add:
            let icon = UIImage(named: "star")
            let button = UIBarButtonItem(image: icon,  style: .plain, target: self, action: #selector(didTapAdd(sender:)))
            button.tintColor = UIColor.white
            return button

        case .discard:
            let icon = UIImage(named: "starSelected")
            let button = UIBarButtonItem(image: icon,  style: .plain, target: self, action: #selector(didTapDiscard(sender:)))
            button.tintColor = UIColor.white
            return button

        case .search:
            let icon = UIImage(named: "search")
            let button = UIBarButtonItem(image: icon,  style: .plain, target: self, action: #selector(didTapSearch(sender:)))
            button.tintColor = UIColor.white
            return button
        case .dismiss:
            let icon = UIImage(named: "dismiss")
            let button = UIBarButtonItem(image: icon,  style: .plain, target: self, action: #selector(didTapDismiss(sender:)))
            button.tintColor = UIColor.white
            return button
        default:
            return nil
        }
        
    }
    
    
    @objc func didTapAdd(sender:AnyObject) {
        
    }
    @objc func didTapDiscard(sender:AnyObject) {
        
    }
    @objc func didTapSearch(sender:AnyObject) {
        
    }
    @objc func didTapDismiss(sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reachabilityChangedStatus(reachibility: Reachability) {
        //If you want subscribe reachability and check connection
    }
}

extension BaseViewController {
    
   
    
    func showMessageWith(title: String, message: String) {
        mainThread {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    func showLoader() {
        Loader.show()
    }
    
    func dismissLoader() {
        Loader.dismiss()
    }

}

extension BaseViewController {
    
    @objc class var storyboardName: String {
        return String(describing: self)
    }
    
    @objc class func createFromStoryboard() -> Self {
        let vc = createFromStoryboard(named: storyboardName, type: self)
        if let vc = vc as? UIViewController {
            vc.modalPresentationStyle = .fullScreen
        }
        return vc
    }
    
    static func createFromStoryboard<T: BaseViewController>(named storyboardName: String?, type: T.Type) -> T {
        let vc = UIStoryboard(name: storyboardName ?? self.storyboardName, bundle: Bundle.main).instantiateInitialViewController() as! T
        if let vc = vc as? UIViewController {
            vc.modalPresentationStyle = .fullScreen
        }
        return vc
    }
    
    
}



enum NavigationItem {
    
    case search
    case add
    case discard
    case dismiss
    
}
