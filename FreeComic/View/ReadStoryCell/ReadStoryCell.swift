//
//  ReadStoryCell.swift
//  FreeComic
//
//  Created by Enrik on 1/12/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class ReadStoryCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var singleTap: UITapGestureRecognizer!
    var doubleTap: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupScrollView()
        setupImageView()
    }

    func setupScrollView(){
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 0
        self.scrollView.maximumZoomScale = 4
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        setZoomScale()
        scrollViewDidZoom(scrollView)
        
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
    // MARK: xu ly tap
    
    func doubleTapGesture(_ gesture: UITapGestureRecognizer) {
        // zoom in, zoom out 
        if (scrollView.zoomScale >= scrollView.maximumZoomScale/2) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let center = gesture.location(in: gesture.view)
            let zoomRect = zoomRectForScale(scrollView.minimumZoomScale * 2, center: center)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.size.width = scrollView.frame.size.width / scale
        
        // choose origin to get the right center 
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect 
    }
    
}
extension ReadStoryCell: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        
        if (verticalPadding >= 0) {
            // Can giua man hinh 
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            scrollView.contentSize = imageViewSize
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
