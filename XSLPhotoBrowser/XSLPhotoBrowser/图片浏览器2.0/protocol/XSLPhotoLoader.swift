//
//  XSLPhotoLoader.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/27.
//  Copyright © 2018 廖佩志. All rights reserved.
//
import UIKit
import Foundation

public protocol XSLPhotoLoader {
    /// 取缓存的图片对象
    func imageCached(on imageView: UIImageView, url: URL?) -> UIImage?

    /// 加载图片并设置给 imageView
    /// 加载本地图片时，url 为空，placeholder 为本地图片
    func setImage(on imageView: UIImageView,
                  url: URL?,
                  placeholder: UIImage?,
                  progressBlock: @escaping (_ receivedSize: Int64, _ totalSize: Int64) -> Void,
                  completionHandler: @escaping () -> Void)
}
