//
//  ReadOfflineStoryVC.swift
//  FreeComic
//
//  Created by Enrik on 2/14/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class ReadOfflineStoryVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layoutCollectionView: UICollectionViewFlowLayout!
    
    @IBOutlet weak var labelPageNumber: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var viewBar: UIView!
    
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var buttonBookmark: UIButton!
    
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var botBarHeightConstraint: NSLayoutConstraint!

    let cellIdentifier = "CollectionCell"
    
    var tapGesture: UITapGestureRecognizer!
    
    var listImages = [Data]()
    var offlineStory: OfflineStory!
    var chapter: OfflineChapter!
    var pageNow = 0
    var isTapScreen: Bool = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: Constant.ReadStoryVC.NibName.collectionViewCell, bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
        
        layoutCollectionView.scrollDirection = .horizontal
        layoutCollectionView.minimumLineSpacing = 0
        layoutCollectionView.minimumInteritemSpacing = 0
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.labelTitle.text = self.chapter.chapterName
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        tapGesture.numberOfTouchesRequired  = 1
        view.addGestureRecognizer(tapGesture)
        
        addTargetsForButtons()
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        self.labelPageNumber.text = "\(self.pageNow + 1) - \(self.listImages.count)"
    }
    
    func addTargetsForButtons() {
        self.buttonBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
    }
    
    @objc func actionBack() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func tapScreen() {
        if self.isTapScreen {
            self.labelPageNumber.isHidden = true
            self.bottomBar.isHidden = true
            self.viewBar.isHidden = true
            UIApplication.shared.isStatusBarHidden = true
            view.updateFocusIfNeeded()
            self.isTapScreen = false
        } else {
            self.labelPageNumber.isHidden = false
            self.bottomBar.isHidden = false
            self.viewBar.isHidden = false
            UIApplication.shared.isStatusBarHidden = false
            view.updateFocusIfNeeded()
            self.isTapScreen = true
        }
    }
    
    func requestData() {
        let listData = self.chapter.images
        self.listImages = []
        for imageData in listData {
            self.listImages.append(imageData.dataImage as! Data)
        }
        self.collectionView.reloadData()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        self.pageNow = pageNumber
        self.labelPageNumber.text = "\(self.pageNow + 1) - \(self.listImages.count)"
    }
    
    //SAVE IMAGE TO LIBRARY 
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your Photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func actionSaveImage(_ sender: Any) {
        let indexPath = IndexPath(item: pageNow, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! ReadStoryCell
        let image = cell.imageView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

}

extension ReadOfflineStoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! ReadStoryCell
        
        let image = UIImage(data: self.listImages[indexPath.row])
        
        cell.imageView.image = image
        
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        return cell
    }
    
}

extension ReadOfflineStoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}


