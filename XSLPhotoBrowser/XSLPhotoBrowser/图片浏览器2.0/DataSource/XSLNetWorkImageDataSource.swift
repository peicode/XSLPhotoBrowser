//
//  XSLNetWorkImageDataSource.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/6.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

class XSLNetWorkImageDataSource: NSObject, XSLPhotoBrowserBaseDataSource {
    /// 弱引用 PhotoBrowser
    public weak var browser: XSLPhotoBrowser?
    let cellID = "XSLPhotoBrowserNetWorkCell"
    /// 共有多少项
    public var numberOfItemsCallback: () -> Int

    /// 每一项的图片对象
    public var placehodleImageCallback: (Int) -> UIImage?

    /// 每一项的图片的URL
    public var loadURLImageCallback: (Int) -> String?


    public init(numberOfItems: @escaping () -> Int, placeholder: @escaping (Int) -> UIImage?, urlCallback: @escaping (Int) -> String?) {
        self.numberOfItemsCallback = numberOfItems
        self.placehodleImageCallback = placeholder
        self.loadURLImageCallback = urlCallback
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsCallback()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! XSLPhotoBrowserNetWorkCell
        cell.reloadData(placeholder: placehodleImageCallback(indexPath.item), autoloadURLString: loadURLImageCallback(indexPath.item))
//        cell.imageView.kf.setImage(with: URL(string: loadURLImageCallback(indexPath.item)!))
//        cell.imageView.kf.setImage(with: URL(string: loadURLImageCallback(indexPath.item)!), placeholder: nil, options: KingfisherOptionsInfo?, progressBlock: , completionHandler: )
        return cell
    }
    
    func registerCell(for collectionView: UICollectionView) {
        collectionView.register(XSLPhotoBrowserNetWorkCell.self, forCellWithReuseIdentifier: "XSLPhotoBrowserNetWorkCell")
    }

}
