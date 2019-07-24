//
//  XSLSDPhotoLoader.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/1/9.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit
import SDWebImage

open class XSLSDPhotoLoader: XSLPhotoLoader {
    public func imageCached(url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        let cache = SDWebImageManager.shared().imageCache
        return cache?.imageFromCache(forKey: url.absoluteString)
    }

    public func setImage(on imageView: UIImageView, url: URL?, placeholder: UIImage?, progressBlock: @escaping (Int64, Int64) -> Void, completionHandler: @escaping () -> Void) {
        imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], progress: { (reciverData, totalData, _) in
            progressBlock(Int64(reciverData), Int64(totalData))
        }) { (_, _, _, _) in
            completionHandler()
        }
    }


}
