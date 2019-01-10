//
//  XSLPhotoBrowserCustomDelegate.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/1/10.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit

open class XSLPhotoBrowserCustomDelegate: XSLPhotoBrowserDelegate {
    open lazy var offsetX: CGFloat = {
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            guard let areaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
                return 0
            }
            return areaBottom
        }
        return 0
    }()
    open func SafeTop(y: CGFloat) -> CGFloat {
        if #available(iOS 11.0, *) {
            guard let areaTop = UIApplication.shared.keyWindow?.safeAreaInsets.top else {
                return y
            }
            return y + areaTop
        }
        return y
    }

    open lazy var offsetY: CGFloat = {
        if #available(iOS 11.0, *) {
            guard let areaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
                return 0
            }
            return areaBottom
        }
        return 0
    }()
    ///
    open lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: SafeTop(y: 0), width: UIScreen.main.bounds.width, height: 44))
        view.layer.shadowColor = UIColor.white.cgColor

        return view
    }()

    open lazy var bottomView: UIView = {
        let heigt: CGFloat = 44.0
        let y = UIScreen.main.bounds.height - heigt - offsetY
        let view = UIView(frame: CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 44))
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.white.cgColor
        return view
    }()

    open override func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool) {
        super.photobrowser(browser, viewDidLoad: animated)
        browser.view.addSubview(headerView)
        browser.view.addSubview(bottomView)

        self.cellIsDraging =  { [weak self] in
            self?.headerView.isHidden = true
            self?.bottomView.isHidden = true
        }

        self.cellEndDrag = { [weak self] in
            self?.headerView.isHidden = false
            self?.bottomView.isHidden = false
        }
    }
    public override init() {
        super.init()
    }

}
