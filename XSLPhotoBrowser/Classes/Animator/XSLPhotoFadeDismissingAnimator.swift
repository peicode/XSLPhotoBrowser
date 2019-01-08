//
//  XSLPhotoFadeDismissingAnimator.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit
import Foundation

public class XSLPhotoFadeDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = self.transitionDuration(using: transitionContext)
        if let view = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

}
