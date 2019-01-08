//
//  XSLPresentAnimatedTransitioning.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit
import Foundation

open class XSLPhotoFadePresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .to) {
            containView.addSubview(view)
            view.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
