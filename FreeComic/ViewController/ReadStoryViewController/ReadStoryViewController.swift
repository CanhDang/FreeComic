//
//  ReadStoryViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/12/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Kingfisher

class ReadStoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layoutCollectionView: UICollectionViewFlowLayout!
    
    @IBOutlet weak var labelPageNumber: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    var tapGesture: UITapGestureRecognizer!
    
    var isTapScreen: Bool = true
    var listImage = [Image]()
    var pageNow = 0
    var chapter: Chapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestData()
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: Constant.ReadStoryVC.NibName.collectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constant.ReadStoryVC.Identifier.collectionViewCell)
        
        layoutCollectionView.scrollDirection = .horizontal
        layoutCollectionView.minimumLineSpacing = 0
        layoutCollectionView.minimumInteritemSpacing = 0
        self.automaticallyAdjustsScrollViewInsets = false
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCollectionView.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layoutCollectionView.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let indexPath = IndexPath(item: pageNow, section: 0)
        if let currentCell = collectionView.cellForItem(at: indexPath) as? ReadStoryCell {
            currentCell.setupImageView()
        }
    }
    
    func requestData() {
        
        let link = String(format: Constant.Request.requestChapter, self.chapter.id)
        
        DownloadManager.share.downloadDetailChapter(stringURL: link) { (images) in
            
            if images != nil {
                self.listImage = images!
                self.labelPageNumber.text = "\(self.pageNow + 1) - \(self.listImage.count)"
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func tapScreen(){
        if isTapScreen {
            labelPageNumber.isHidden = true
            UIApplication.shared.isStatusBarHidden = true
            //navigationController?.setNavigationBarHidden(true, animated: false)
            buttonBack.isHidden = true
            view.updateFocusIfNeeded()
            isTapScreen = !isTapScreen
        }else{
            UIApplication.shared.isStatusBarHidden = false
            //navigationController?.setNavigationBarHidden(false, animated: false)
            buttonBack.isHidden = false 
            labelPageNumber.isHidden = false
            view.updateFocusIfNeeded()
            isTapScreen = true
        }
    }
    
    // Xoay man hinh 
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
        collectionView.collectionViewLayout.invalidateLayout() //-- update  lai layout
        //-- khi scroll den item nao thi update lai
        let indexPath = IndexPath(item: pageNow, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.layoutCollectionView.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            
            
            if let currentCell = self.collectionView.cellForItem(at: indexPath) as? ReadStoryCell {
                currentCell.setupImageView()
            }
            self.collectionView.reloadData()
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageNow = pageNumber
        self.labelPageNumber.text = "\(pageNumber + 1) - \(self.listImage.count)"
    }
    
}


extension ReadStoryViewController: UICollectionViewDelegate {
    // begin 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let url = URL(string: listImage[indexPath.item].link)
        (cell as! ReadStoryCell).imageView.kf.setImage(with: url)
    }
    
    // end 
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ReadStoryCell).imageView.kf.cancelDownloadTask()
    }
}

extension ReadStoryViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.ReadStoryVC.Identifier.collectionViewCell, for: indexPath) as! ReadStoryCell
        cell.imageView.kf.indicatorType = .activity
        
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexPath in indexPaths {
            if let url = URL(string: listImage[indexPath.item].link) {
                urls.append(url)
            }
        }
        
        ImagePrefetcher(urls: urls).start()
    }
}

extension ReadStoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}








