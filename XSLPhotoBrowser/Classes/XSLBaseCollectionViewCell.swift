//
//  XSLBaseCollectionViewCell.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/5.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

open class XSLBaseCollectionViewCell: UICollectionViewCell {
    /// imageView
    open lazy var imageView = UIImageView()
    /// ScrollView
    open lazy var imageContainer = UIScrollView()

    /// 图片单击时的回调
    open var clickCallback: (() -> Void)?

    /// 图片拖动时回调
    open var panChangedCallback: ((_ scale: CGFloat) -> Void)?

    /// 图片拖动松手回调。isDown: 是否向下
    open var panReleasedCallback: ((_ isDown: Bool) -> Void)?

    ///
    open var longPressCallback: ((_ longGesture: UILongPressGestureRecognizer) -> Void)?
    /// 是否需要添加长按手势。子类可重写本属性，返回`false`即可避免添加长按手势
    open var isNeededLongPressGesture: Bool {
        return true
    }

    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero

    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    /// 计算图片复位坐标
    private var resettingCenter: CGPoint {
        let deltaWidth = bounds.width - imageContainer.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - imageContainer.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: imageContainer.contentSize.width * 0.5 + offsetX,
                       y: imageContainer.contentSize.height * 0.5 + offsetY)
    }

    /// 计算图片适合的size
    private var fitSize: CGSize {
        guard let image = imageView.image else {
            return CGSize.zero
        }
        var width: CGFloat
        var height: CGFloat
        if imageContainer.bounds.width < imageContainer.bounds.height {
            // 竖屏
            width = imageContainer.bounds.width
            height = (image.size.height / image.size.width) * width
        } else {
            // 横屏
            height = imageContainer.bounds.height
            width = (image.size.width / image.size.height) * height
            if width > imageContainer.bounds.width {
                width = imageContainer.bounds.width
                height = (image.size.height / image.size.width) * width
            }
        }
        return CGSize(width: width, height: height)
    }
    /// 计算图片适合的frame
    private var fitFrame: CGRect {
        let size = fitSize
        let y = imageContainer.bounds.height > size.height
            ? (imageContainer.bounds.height - size.height) * 0.5 : 0
        let x = imageContainer.bounds.width > size.width
            ? (imageContainer.bounds.width - size.width) * 0.5 : 0
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    /// 复位ImageView
    private func resetImageView() {
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = fitSize
        let needResetSize = imageView.bounds.size.width < size.width
            || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.resettingCenter
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.frame = contentView.bounds
        imageContainer.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        imageContainer.setZoomScale(1.0, animated: false)
//        imageView.center = CGPoint(x: imageContainer.bounds.width / 2, y: imageContainer.bounds.height / 2)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageContainer)
        imageContainer.maximumZoomScale = 2.0
        imageContainer.delegate = self
        imageContainer.showsVerticalScrollIndicator = false
        imageContainer.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            imageContainer.contentInsetAdjustmentBehavior = .never
        }
        imageContainer.addSubview(imageView)
        imageView.clipsToBounds = true

        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(onclick))
        contentView.addGestureRecognizer(tap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleClick(_:)))
        doubleTap.numberOfTapsRequired = 2
        tap.require(toFail: doubleTap)
        contentView.addGestureRecognizer(doubleTap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panPhotoBrowser(_:)))
        pan.delegate = self as UIGestureRecognizerDelegate
        imageContainer.addGestureRecognizer(pan)

        if isNeededLongPressGesture {
            let long = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            contentView.addGestureRecognizer(long)
        }
    }
}
//MARK: -UIScrollViewDelegate
extension XSLBaseCollectionViewCell: UIScrollViewDelegate {
    //将要缩放的UIView对象
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    /// 需要在缩放的时候调用
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = resettingCenter
    }
}

// MARK: - 点击事件
extension XSLBaseCollectionViewCell {
    @objc func onclick() {
        clickCallback?()
    }
    @objc func doubleClick(_ dbTap: UITapGestureRecognizer) {
        // 如果当前没有任何缩放，则放大到目标比例
        let scale = imageContainer.maximumZoomScale
        // 否则重置到原比例
        if imageContainer.zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = dbTap.location(in: imageView)
            let w = imageContainer.bounds.size.width / scale
            let h = imageContainer.bounds.size.height / scale
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            let rect = CGRect(x: x, y: y, width: w, height: h)
            imageContainer.zoom(to: rect, animated: true)
        } else {
            imageContainer.setZoomScale(1.0, animated: true)
        }

    }

    @objc func panPhotoBrowser(_ pan: UIPanGestureRecognizer) {
        guard imageView.image != nil else {
            return
        }
        switch pan.state {
        case .began:
            beganFrame = imageView.frame
            beganTouch = pan.location(in: imageContainer)
        case .changed:
            let result = panResult(pan)
            imageView.frame = result.0
            panChangedCallback?(result.1)
        case .ended, .cancelled:
            imageView.frame = panResult(pan).0
            let isDown = pan.velocity(in: self).y > 0
            self.panReleasedCallback?(isDown)
            if !isDown {
                resetImageView()
            }
        default:
            resetImageView()
        }
    }
    /// 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (CGRect, CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: imageContainer)
        let currentTouch = pan.location(in: imageContainer)

        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))

        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale

        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX

        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY

        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    @objc func longPress(_ longGesture: UILongPressGestureRecognizer) {
        if longGesture.state == .began {
            longPressCallback?(longGesture)
        }
    }
}
// MARK: - UIGestureRecognizerDelegate
extension XSLBaseCollectionViewCell: UIGestureRecognizerDelegate {
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else{
            return true
        }
        //在指定视图的坐标系中平移手势的速度。
        let velocity = pan.velocity(in: self)
        //向上滑动，不响应手势
        if velocity.y < 0 {
            return false
        }
        //横向滑动时，不响应Pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        //向下滑动，如果图片顶部超出可视范围，不响应
        if imageContainer.contentOffset.y > 0 {
            return false
        }
        return true
    }
}
