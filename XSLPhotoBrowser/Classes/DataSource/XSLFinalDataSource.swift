//
//  XSLFinalDataSource.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/7/24.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit

class XSLFinalDataSource: NSObject, XSLPhotoBrowserBaseDataSource {
    /// 弱引用 PhotoBrowser
    weak public var browser: XSLPhotoBrowser?
    let cellID = "XSLPhotoBrowserNetWorkCell"
    /// 共有多少项
    public var numberOfItems: Int

    /// 每一项的图片对象
    public var localImageCallback: (_ index: Int) -> UIImage?

    /// 站位图
    public var placeholderImageCallback: (_ index: Int) -> UIImage?

    /// 每一项的图片的URL
    public var netWorkImageCallback: (_ index: Int) -> String?

    public init(numberOfItems: Int, localImageCallback: @escaping (_ index: Int) -> UIImage?, netWorkImageCallback: @escaping(_ index: Int) -> String?, placeholderImageCallback: @escaping(_ index: Int) -> UIImage?) {
        self.numberOfItems = numberOfItems
        self.localImageCallback = localImageCallback
        self.netWorkImageCallback = netWorkImageCallback
        self.placeholderImageCallback = placeholderImageCallback
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! XSLPhotoBrowserNetWorkCell
        let urlString = netWorkImageCallback(indexPath.item)
        let placeholder = placeholderImageCallback(indexPath.item)
        let localImage = localImageCallback(indexPath.item)
        if (localImage != nil) {
            cell.progressView.isHidden = true
            cell.imageView.image = localImage
        }else {
            cell.progressView.isHidden = false
            cell.reloadData(placeholder: placeholder, autoloadURLString: urlString)
        }
        return cell
    }

    public func registerCell(for collectionView: UICollectionView) {
        collectionView.register(XSLPhotoBrowserNetWorkCell.self, forCellWithReuseIdentifier: "XSLPhotoBrowserNetWorkCell")
    }

}
