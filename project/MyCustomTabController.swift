//
//  MyCustomTabController.swift
//  project
//
//  Created by Канапия Базарбаев on 30.03.2024.
//

import UIKit

class MyCustomTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
}

extension UITabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = tabBarController.selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        guard tabBarController.selectedViewController != viewController else {
            return false
        }
        
        let isMovingLeft = tabBarController.selectedIndex < (tabBarController.viewControllers?.firstIndex(of: viewController) ?? 0)
        
        if isMovingLeft {
            toView.frame = CGRect(x: tabBarController.view.frame.size.width, y: 0, width: tabBarController.view.frame.size.width, height: tabBarController.view.frame.size.height)
        } else {
            toView.frame = CGRect(x: -tabBarController.view.frame.size.width, y: 0, width: tabBarController.view.frame.size.width, height: tabBarController.view.frame.size.height)
        }
        
        tabBarController.view.addSubview(toView)
        
        UIView.animate(withDuration: 0.3, animations: {
            if isMovingLeft {
                fromView.frame = CGRect(x: -tabBarController.view.frame.size.width, y: 0, width: tabBarController.view.frame.size.width, height: tabBarController.view.frame.size.height)
            } else {
                fromView.frame = CGRect(x: tabBarController.view.frame.size.width, y: 0, width: tabBarController.view.frame.size.width, height: tabBarController.view.frame.size.height)
            }
            toView.frame = CGRect(x: 0, y: 0, width: tabBarController.view.frame.size.width, height: tabBarController.view.frame.size.height)
        }) { (finished) in
            fromView.removeFromSuperview()
        }
        return true
    }
}
