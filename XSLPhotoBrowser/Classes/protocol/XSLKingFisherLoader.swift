//
//  XSLKingFisherLoader.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/27.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit
import Kingfisher

public class XSLKingFisherLoader: XSLPhotoLoader {

    public func imageCached(on imageView: UIImageView, url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        let cache = KingfisherManager.shared.cache
        let result = cache.imageCachedType(forKey: url.cacheKey)
        switch result {
        case .none:
            return nil
        case .memory:
            return cache.retrieveImageInMemoryCache(forKey: url.cacheKey)
        case .disk:
            return cache.retrieveImageInDiskCache(forKey: url.cacheKey)
        }
    }

    public func setImage(on imageView: UIImageView, url: URL?, placeholder: UIImage?, progressBlock: @escaping (Int64, Int64) -> Void, completionHandler: @escaping () -> Void) {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [], progressBlock: { (reciveData, totalData) in
            progressBlock(reciveData, totalData)
        }) { (_, _, _, _) in
            completionHandler()
        }
    }
}
