//
//  XSLPhotoBrowserDelegate
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/5.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

public protocol XSLPhotoBrowserBaseDelegate: UICollectionViewDelegate {
    var browser: XSLPhotoBrowser? {set get}
    /// pageIndex 值改变时回调
    func photoBrowser(_ browser: XSLPhotoBrowser, pageIndexDidChanged pageIndex: Int)

    /// 取当前显示页的内容视图。比如是 ImageView.
    func displayingContentView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView?
    /// 取当前动画的image
    func transitionImage(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIImage?
    /// 关闭
    func dismissPhotoBrowser(_ browser: XSLPhotoBrowser)

    /// 数据源已刷新
    func photoBrowserDidReloadData(_ browser: XSLPhotoBrowser)

    /// viewDidLoad
    func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool)
}

open class XSLPhotoBrowserDelegate: NSObject, XSLPhotoBrowserBaseDelegate {
    open weak var browser: XSLPhotoBrowser?
    /// cellisDrag
    open var cellIsDraging: (() -> Void)?
    /// cellEndDrag
    open var cellEndDrag: (() -> Void)?
    /// 长按回调。回传参数分别是：浏览器，图片序号，图片对象，手势对象
    open var longPressedCallback: ((XSLPhotoBrowser, Int, UIImage?, UILongPressGestureRecognizer) -> Void)?
    /// 图片的contentMode
    open var contentMode: UIView.ContentMode = .scaleToFill
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? XSLBaseCollectionViewCell else {
            return
        }
        cell.imageView.contentMode = contentMode

        cell.clickCallback = {
            self.dismiss()
        }
        //开始拖拽
        cell.panChangedCallback = { [weak self] scale in
            let alpha = scale * scale
            self?.browser?.transDelegate.maskAlpha = alpha
            self?.cellIsDraging?()
            //需不需要显示状态栏
        }
        // 结束拖拽
        cell.panReleasedCallback = { [weak self] isDown in
            if isDown {
                self?.dismiss()
            } else {
                self?.browser?.transDelegate.maskAlpha = 1.0
                self?.cellEndDrag?()
            }
        }
        //长按
        weak var weakCell = cell
        cell.longPressCallback = { gesture in
            if let browser = self.browser {
                self.longPressedCallback?(browser, indexPath.item, weakCell?.imageView.image, gesture)
            }
        }
    }
    /// 退出
    open func dismiss() {
        browser?.dismiss(animated: true, completion: nil)
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        browser?.pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }

    open func transitionImage(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIImage? {
        let indexPath = IndexPath(item: pageIndex, section: 0)
        let cell = browser.collectionView.cellForItem(at: indexPath) as? XSLBaseCollectionViewCell
        return cell?.imageView.image
    }
    
    open func displayingContentView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView? {
        let indexPath = IndexPath.init(item: pageIndex, section: 0)
        let cell = browser.collectionView.cellForItem(at: indexPath) as? XSLBaseCollectionViewCell
        return cell?.imageView
    }

    open func dismissPhotoBrowser(_ browser: XSLPhotoBrowser) {
        self.dismiss()
    }

    open func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool) {
        
    }
    open func photoBrowserDidReloadData(_ browser: XSLPhotoBrowser) {

    }
    open func photoBrowser(_ browser: XSLPhotoBrowser, pageIndexDidChanged pageIndex: Int) {

    }


}
