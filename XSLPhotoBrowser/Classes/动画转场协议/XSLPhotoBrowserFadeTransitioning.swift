//
//  XSLPhotoBrowserFadeTransitioning.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit
import Foundation

public class XSLPhotoBrowserFadeTransitioning: XSLPhotoBrowserTransitioning {
    public override init() {
        super.init()
        self.presentingAnimator = XSLPhotoFadePresentingAnimator()
        self.dismissAnimator = XSLPhotoFadeDismissingAnimator()
    }
}
