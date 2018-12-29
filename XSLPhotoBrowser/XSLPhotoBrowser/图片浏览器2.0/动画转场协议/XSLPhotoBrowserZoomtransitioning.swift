//
//  XSLPhotoBrowserZoomtransitioning.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

class XSLPhotoBrowserZoomtransitioning: XSLPhotoBrowserTransitioning {
//    var originView: UIView
//    var originViewFrame: CGRect
//    public init(transView: UIView) {
//        originView = transView
//        originViewFrame = transView.frame
//        super.init()
//        setupPresent()
//        setupDisMiss()
//
//    }
//
//    func setupPresent() {
//        self.presentingAnimator = XSLPhotoBrowserZoomPresentingAnimator(zoomView: { () -> UIView? in
//            let view = self.browser?.transitionZoomView
//            view?.contentMode = .scaleAspectFill
//            view?.clipsToBounds = true
////            return view
//            return self.originView
//        }, startFrame: { (view) -> CGRect? in
//            //得到CollectionView开始时的cell的Frame
//            return self.originView.convert(self.originView.bounds, to: view)
//        }, endFrame: { (view) -> CGRect? in
////            let tmpView = self.browser?.transitionZoomView
//            let tmpView = self.browser?.imageForCollectionViewCell
//            return tmpView?.convert((tmpView?.bounds)!, to: view)
////            let imageW = self.originView.bounds.width
////            let y = (UIScreen.main.bounds.height - imageW * UIScreen.main.scale) * 0.5
////            return CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: imageW * UIScreen.main.scale)
////            return nil
//        })
//    }
//
//    func setupDisMiss() {
//        self.dismissAnimator = XSLPhotoBrowserZoomDismissingAnimator(zoomView: { [weak self]() -> UIView? in
//            guard let strongSelf = self else {
//                return nil
//            }
//            let view = strongSelf.browser?.transitionZoomView
//            view?.contentMode = .scaleAspectFill
//            return view
//        }, startFrame: { (view) -> CGRect? in
//            if let tmpView = self.browser?.imageForCollectionViewCell {
//                return tmpView.convert(tmpView.bounds, to: view)
//            }
//            return nil
//        }, endFrame: { (view) -> CGRect? in
//            return self.originView.convert(self.originView.bounds, to: view)
//        })
//    }

    /////////
    /// present转场时，内容缩张模式
    public var presentingZoomViewMode: () -> UIView.ContentMode = {
        return UIView.ContentMode.scaleAspectFill
    }

    /// dismiss转场时，内容缩张模式
    public var dismissingZoomViewMode: () -> UIView.ContentMode = {
        return UIView.ContentMode.scaleAspectFill
    }

    //
    // MARK: - 用户传入 ZoomView 的前置页面 Frame
    //

    public typealias FrameClosure = (
        _ browser: XSLPhotoBrowser,
        _ pageIndex: Int,
        _ transContainer: UIView) -> CGRect?

    /// 取前置视图的Frame
    public var originFrameCallback: FrameClosure

    /// 初始化，传入动画 起始/结束 的前置视图 Frame
    public init(originFrameCallback: @escaping FrameClosure) {
        self.originFrameCallback = originFrameCallback
        super.init()
        setupPresenting()
        setupDismissing()
    }

    //
    // MARK: - 用户传入 ZoomView 的前置页面视图
    //

    public typealias ViewClosure = (
        _ browser: XSLPhotoBrowser,
        _ pageIndex: Int,
        _ transContainer: UIView) -> UIView?

    /// 初始化，传入动画 起始/结束 的前置视图
    public convenience init(originViewCallback: @escaping ViewClosure) {
        let callback: FrameClosure = { (browser, index, view) -> CGRect? in
            if let oriView = originViewCallback(browser, index, view) {
                return oriView.convert(oriView.bounds, to: view)
            }
            return nil
        }
        self.init(originFrameCallback: callback)
    }

    private func setupPresenting() {
        weak var `self` = self
        presentingAnimator = XSLPhotoBrowserZoomPresentingAnimator(zoomView: { () -> UIView? in
            guard let `self` = self else {
                print("JXPhotoBrowser.Transitioning.Zoom 已被释放.")
                return nil
            }
            let view = self.browser?.transitionZoomView
            view?.contentMode = self.presentingZoomViewMode()
            view?.clipsToBounds = true
            return view
        }, startFrame: { view -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrameCallback(browser, browser.pageIndex, view)
            }
            return nil
        }, endFrame: { view -> CGRect? in
            if let contentView = self?.browser?.imageForCollectionViewCell {
                return contentView.convert(contentView.bounds, to: view)
            }
            return nil
        })
    }

    private func setupDismissing() {
        weak var `self` = self
        dismissAnimator = XSLPhotoBrowserZoomDismissingAnimator(zoomView: { () -> UIView? in
            guard let `self` = self else {
                print("JXPhotoBrowser.Transitioning.Zoom 已被释放.")
                return nil
            }
            let view = self.browser?.transitionZoomView
            view?.contentMode = self.dismissingZoomViewMode()
            view?.clipsToBounds = true
            return view
        }, startFrame: { view -> CGRect? in
            if let contentView = self?.browser?.imageForCollectionViewCell {
                return contentView.convert(contentView.bounds, to: view)
            }
            return nil
        }, endFrame: { view -> CGRect? in
            if let browser = self?.browser {
                return self?.originFrameCallback(browser, browser.pageIndex, view)
            }
            return nil
        })
    }

}
