//
//  UIAplication.swift
//  campus-go
//
//  Created by Giordano Mattiello on 30/11/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}

extension UIApplication {
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }
        
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}
func getCurrentViewController() -> UIViewController? {

    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {

        return navigationController.visibleViewController
    }

    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindowPresentedController {

        var currentController: UIViewController! = rootController

        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {

            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}

func getNavigationController() -> UINavigationController? {

    if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {

        return navigationController as? UINavigationController
    }
    return nil
}


