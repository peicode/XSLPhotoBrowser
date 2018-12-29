//
//  XSLPhotoBrowserDelegate
//  Third-party-framework
//
//  Created by 廖佩志 on 2018/12/5.
//  Copyright © 2018 廖佩志. All rights reserved.
//

import UIKit

protocol XSLPhotoBrowserBaseDelegate: UICollectionViewDelegate {
    var browser: XSLPhotoBrowser? {set get}
    /// pageIndex 值改变时回调
    func photoBrowser(_ browser: XSLPhotoBrowser, pageIndexDidChanged pageIndex: Int)

    /// 取当前显示页的内容视图。比如是 ImageView.
    func displayingContentView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView?

    /// 取转场动画视图
    func transitionZoomView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView?

    /// 关闭
    func dismissPhotoBrowser(_ browser: XSLPhotoBrowser)

    /// 数据源已刷新
    func photoBrowserDidReloadData(_ browser: XSLPhotoBrowser)

    /// viewDidLoad
    func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool)
}

class XSLPhotoBrowserDelegate: NSObject, XSLPhotoBrowserBaseDelegate {
    weak var browser: XSLPhotoBrowser?
    /// cellisDrag
    var cellIsDraging: (() -> Void)?
    /// cellEndDrag
    var cellEndDrag: (() -> Void)?
    /// 长按回调。回传参数分别是：浏览器，图片序号，图片对象，手势对象
    var longPressedCallback: ((XSLPhotoBrowser, Int, UIImage?, UILongPressGestureRecognizer) -> Void)?
    /// 图片的contentMode
    var contentMode: UIView.ContentMode = .scaleToFill
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? XSLBaseCollectionViewCell else {
            return
        }
        cell.imageView.contentMode = contentMode

        cell.clickCallback = {
            self.dismiss()
        }
        //开始拖拽
        cell.panChangedCallback = { scale in
            let alpha = scale * scale
            self.browser?.transDelegate.maskAlpha = alpha
            self.cellIsDraging?()
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
    func dismiss() {
        browser?.dismiss(animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        browser?.pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }

    func displayingContentView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView? {
        let indexPath = IndexPath.init(item: pageIndex, section: 0)
        let cell = browser.collectionView.cellForItem(at: indexPath) as? XSLBaseCollectionViewCell
        return cell?.imageView
    }

    func transitionZoomView(_ browser: XSLPhotoBrowser, pageIndex: Int) -> UIView? {
        let indexPath = IndexPath(item: pageIndex, section: 0)
        let cell = browser.collectionView.cellForItem(at: indexPath) as? XSLBaseCollectionViewCell
        return UIImageView(image: cell?.imageView.image)
    }

    func dismissPhotoBrowser(_ browser: XSLPhotoBrowser) {
        self.dismiss()
    }

    func photobrowser(_ browser: XSLPhotoBrowser, viewDidLoad animated: Bool) {
        
    }
    func photoBrowserDidReloadData(_ browser: XSLPhotoBrowser) {

    }
    func photoBrowser(_ browser: XSLPhotoBrowser, pageIndexDidChanged pageIndex: Int) {

    }


}
