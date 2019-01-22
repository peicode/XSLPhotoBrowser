//
//  UIViewController+XSL.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/1/22.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: XSLNamespaceWrappable {}

extension XSLTypeWrapperProtocol where XSLWrappedType == UIViewController {
    public static var topMost: UIViewController? {
        var rootWindowController: UIViewController?
        for window in UIApplication.shared.windows {
            if let rootController = window.rootViewController {
                rootWindowController = rootController
            }
        }
        return self.topMost(of: rootWindowController)
    }

    public static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}

