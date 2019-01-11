//
//  XSLPhotoBrowserProgressView.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/27.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

open class XSLPhotoBrowserProgressView: UIView {

    open var progress: CGFloat = 0 {
        didSet {
            if progress < 0.05 {
                progress = 0.05
            }
            annulusLayer.path = makeProgressPath(progress: progress)
        }

    }

    open var circleLayer: CAShapeLayer!
    open var annulusLayer: CAShapeLayer!
    private var originFrame: CGRect!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if self.frame.size.equalTo(.zero) {
            self.frame = CGRect(x: (UIScreen.main.bounds.width+30), y: UIScreen.main.bounds.height / 2, width: 50, height: 50)
        }
        originFrame = frame
        setupUI()
        progress = 0
    }

    private func setupUI() {
        backgroundColor = UIColor.clear

        let strokeColor = UIColor.white.cgColor

        circleLayer = CAShapeLayer()
        circleLayer.strokeColor = strokeColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.path = makeCirclePath()
        layer.addSublayer(circleLayer)

        annulusLayer = CAShapeLayer()
        annulusLayer.fillColor = strokeColor
        annulusLayer.path = makeProgressPath(progress: 0.05)
        layer.addSublayer(annulusLayer)
    }

    open func makeCirclePath() -> CGPath {
        let center = CGPoint(x: originFrame.midX, y: originFrame.maxY)
        let path = UIBezierPath(arcCenter: center, radius: 30, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = 1
        return path.cgPath
    }

    open func makeProgressPath(progress: CGFloat) -> CGPath {
        let center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        let radius: CGFloat = 28
        let path = UIBezierPath()
        path.move(to: center)
        path.addLine(to: CGPoint(x: originFrame.midX, y: originFrame.midY - radius))
        path.addArc(withCenter: center, radius: radius, startAngle: -CGFloat.pi * 0.5, endAngle: -CGFloat.pi * 0.5 + progress * CGFloat.pi * 2, clockwise: true)
        path.close()
        path.lineWidth = 1
        return path.cgPath
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
