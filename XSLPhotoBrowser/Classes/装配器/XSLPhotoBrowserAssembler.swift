//
//  XSLPhotoBrowserAssembler.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/26.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

open class XSLPhotoBrowserAssembler: XSLPhotoBrowserDelegate {

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
    /// quitBtnCallback
    open var quitBtnCallback: ((XSLPhotoBrowserAssembler) -> Void)?
    /// deleteBtnCallback
    open var deleteBtnCallback: ((_ index: Int) -> Void)?

    /// 
    open lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: SafeTop(y: 0), width: UIScreen.main.bounds.width, height: 44))
        view.layer.shadowColor = UIColor.white.cgColor
        let quitBtn = UIButton()
        quitBtn.setImage(UIImage(named: "error"), for: .normal)
        quitBtn.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        quitBtn.addTarget(self, action: #selector(quitBtnClick), for: .touchDown)
        view.addSubview(quitBtn)
        let moreBtn = UIButton()
        moreBtn.setImage(UIImage(named: "more"), for: .normal)
        moreBtn.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 0, width: 30, height: 30)
        moreBtn.addTarget(self, action: #selector(moreBtnClick), for: .touchDown)
        view.addSubview(moreBtn)

        return view
    }()

    open lazy var bottomView: UIView = {
        let heigt: CGFloat = 44.0
        let y = UIScreen.main.bounds.height - heigt - offsetY
        let view = UIView(frame: CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 44))
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.white.cgColor
        let menuBtn = UIButton()
        menuBtn.setImage(UIImage(named: "menu"), for: .normal)
        menuBtn.frame = CGRect(x: 10, y: 0, width: 44, height: 44)
        menuBtn.addTarget(self, action: #selector(menuBtnClick), for: .touchDown)
        view.addSubview(menuBtn)

        let deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "delete"), for: .normal)
        deleteBtn.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 0, width: 30, height: 30)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: .touchDown)
        view.addSubview(deleteBtn)

        return view
    }()

    open override func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool) {
        super.photobrowser(browser, viewDidLoad: animated)
        browser.view.addSubview(headerView)
        browser.view.addSubview(bottomView)
    }
    public override init() {
        super.init()
    }
    @objc open func quitBtnClick() {
        self.dismiss()
    }
    @objc open func moreBtnClick() {

    }
    @objc open func menuBtnClick() {

    }
    @objc open func deleteBtnClick() {
        deleteBtnCallback?(browser?.pageIndex ?? 0)
    }
}
