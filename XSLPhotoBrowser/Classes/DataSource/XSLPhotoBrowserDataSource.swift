//
//  XSLDataSource.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/7/18.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit
import SDWebImage

class XSLPhotoBrowserDataSource: NSObject, XSLPhotoBrowserBaseDataSource {
    /// 弱引用 PhotoBrowser
    weak public var browser: XSLPhotoBrowser?
    let cellID = "XSLPhotoBrowserNetWorkCell"
    /// 共有多少项
    public var numberOfItems: Int

    /// 每一项的图片对象
    public var placehodleImageCallback: (_ index: Int) -> UIImage?

    /// 每一项的图片的URL
    public var loadURLImageCallback: (_ index: Int) -> String?


    public init(numberOfItems: Int, placeholder: @escaping (Int) -> UIImage?, urlCallback: @escaping (Int) -> String?) {
        self.numberOfItems = numberOfItems
        self.placehodleImageCallback = placeholder
        self.loadURLImageCallback = urlCallback
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! XSLPhotoBrowserNetWorkCell
        let str = loadURLImageCallback(indexPath.item)
        let placeholder = placehodleImageCallback(indexPath.item)
        if str?.hasPrefix("http") ?? false {
            cell.reloadData(placeholder: placeholder, autoloadURLString: str)
            return cell
        }
        cell.imageView.image = UIImage(named: str ?? "")
        cell.progressView.isHidden = true
        return cell
    }

    public func registerCell(for collectionView: UICollectionView) {
        collectionView.register(XSLPhotoBrowserNetWorkCell.self, forCellWithReuseIdentifier: "XSLPhotoBrowserNetWorkCell")
    }

}
