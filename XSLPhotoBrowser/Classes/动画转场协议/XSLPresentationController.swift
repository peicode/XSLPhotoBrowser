//
//  XSLPresentationController.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit
import Foundation
open class XSLPresentationController: UIPresentationController {
    //蒙版
    open var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    //transitionCoordinator返回协调器对象
    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else { return }
        containerView.addSubview(maskView)
        maskView.frame = UIScreen.main.bounds
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 1
        }, completion: nil)
    }

    open override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.alpha = 0
        })
    }
}
