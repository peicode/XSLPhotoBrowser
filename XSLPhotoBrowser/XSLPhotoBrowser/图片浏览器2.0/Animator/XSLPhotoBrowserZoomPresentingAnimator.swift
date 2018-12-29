//
//  XSLPhotoBrowserZoomPresentingAnimator.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

class XSLPhotoBrowserZoomPresentingAnimator: XSLPhotoBrowserZoomAnimator , UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containView = transitionContext.containerView
        guard let zView = zoomView(),
              let startFrame = startFrame(containView),
              let endFrame = endFrame(containView) else {
                //执行fade动画
                fadeTransition(using: transitionContext)
                return
        }
        containView.addSubview(zView)
        zView.frame = startFrame
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            zView.frame = endFrame
        }) { (_) in
            if let presentV = transitionContext.view(forKey: .to) {
                containView.addSubview(presentV)
            }
            zView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    func fadeTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
