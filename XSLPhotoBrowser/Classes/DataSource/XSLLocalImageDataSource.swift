//
//  XSLLocalImageDataSource.swift
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/4.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

open class XSLLocalImageDataSource: NSObject, XSLPhotoBrowserBaseDataSource {
    public func registerCell(for collectionView: UICollectionView) {
        collectionView.register(XSLBaseCollectionViewCell.self, forCellWithReuseIdentifier: "XSLBaseCollectionViewCell")
    }
    
    weak public var browser: XSLPhotoBrowser?
    let cellID = "XSLBaseCollectionViewCell"
    //图片总数
    public var numberOfItemCounts: () -> Int

    public var localImageCallback: (Int) -> UIImage?

    public init(numberOfItems: @escaping () -> Int, localImage: @escaping (Int) -> UIImage? ) {
        self.numberOfItemCounts = numberOfItems
        self.localImageCallback = localImage
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemCounts()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! XSLBaseCollectionViewCell
        cell.imageView.image = localImageCallback(indexPath.item)
        return cell
    }
}
