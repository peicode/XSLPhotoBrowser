//
//  XSLPhotoBrowserNetWorkCell.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/27.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

class XSLPhotoBrowserNetWorkCell: XSLBaseCollectionViewCell {
    /// 进度环
    public let progressView = XSLPhotoBrowserProgressView()

    /// 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        progressView.isHidden = true
        contentView.addSubview(progressView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
    }
    var photoLoader: XSLKingFisherLoader {
        let loader = XSLKingFisherLoader()
        return loader
    }
    /// 刷新数据
    open func reloadData(placeholder: UIImage?, autoloadURLString: String?) {
        // 重置环境
        progressView.isHidden = true
        progressView.progress = 0
        // url是否有效
        guard let urlString = autoloadURLString,let url = URL(string: urlString) else {
            imageView.image = placeholder
            setNeedsLayout()
            return
        }
        // 取缓存
        let image = photoLoader.imageCached(on: imageView, url: url)
        let placeholder = image ?? placeholder
        // 加载
        photoLoader.setImage(on: imageView, url: url, placeholder: placeholder, progressBlock: { receivedSize, totalSize in
            if totalSize > 0 {
                self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                if receivedSize < totalSize {
                    self.progressView.isHidden = false
                }
            } else {
                self.progressView.progress = 0
            }
        }) {
            self.progressView.isHidden = true
            self.setNeedsLayout()
        }
        setNeedsLayout()
    }
}
