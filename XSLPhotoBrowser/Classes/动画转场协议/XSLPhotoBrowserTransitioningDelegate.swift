//
//  XSLPhotoBrowserTransitioningDelegate.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import Foundation
import UIKit

public protocol XSLPhotoBrowserTransitioningDelegate: UIViewControllerTransitioningDelegate {
    /// 实现者应弱引用 PhotoBrowser，由 PhotoBrowser 初始化完毕后注入
    var browser: XSLPhotoBrowser? { set get }

    /// 蒙板 alpha 值
    var maskAlpha: CGFloat { set get }
}
