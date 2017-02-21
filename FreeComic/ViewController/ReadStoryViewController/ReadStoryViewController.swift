//
//  ReadStoryViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/12/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ReadStoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layoutCollectionView: UICollectionViewFlowLayout!
    
    @IBOutlet weak var labelPageNumber: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var viewBar: UIView!
    
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var buttonBookmark: UIButton!
    
    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var botBarHeightConstraint: NSLayoutConstraint!
    
    
    var tapGesture: UITapGestureRecognizer!
    
    var isTapScreen: Bool = true
    var listImage = [Image]()
    var pageNow = 0
    var chapter: Chapter!
    var story: Story!
    var detailStory: DetailStory! 
    var pageToScroll: Int!
    
    var isShowingInitial: Bool = true
    
    var isBookmarked: Bool = false
    var initialBookmarked: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            collectionView.prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
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
        
        self.labelTitle.text = self.chapter.name
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.saveBookmark(pageNow + 1)
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveRecentStory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.requestData { (check) in
            if check == true {
                if self.pageToScroll != nil {
                    let indexPath = IndexPath(item: self.pageToScroll, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self.initialBookmarked = true
                    self.isBookmarked = true
                    self.buttonBookmark.setImage(#imageLiteral(resourceName: "bookmarked"), for: .normal)
                    self.isShowingInitial = false
                    self.pageNow = self.pageToScroll
                    self.labelPageNumber.text = "\(self.pageNow + 1) - \(self.listImage.count)"
                } else {
                    self.checkInitialBookmark(self.pageNow + 1)
                }
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        self.checkDownload()
    }
    
    
    func checkDownload() {
        let realm = try! Realm()
        
        let objects = realm.objects(OfflineStory.self)
        
        var isChapterDownloaded = false
        
        for object in objects {
            if object.id == self.story.id {
                for offlineChapter in object.chapters {
                    if offlineChapter.chapterId == self.chapter.id {
                        isChapterDownloaded = true
                        break
                    }
                }
                break
            }
        }
        
        if isChapterDownloaded == true {
            self.buttonDownload.isHidden = true 
        }
        
    }
    
    func saveRecentStory() {
        
        let date = Date()
        let dateFormater = DateFormatter()
//        dateFormater.dateStyle = .medium
//        dateFormater.timeStyle = .short
        dateFormater.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let timeString = dateFormater.string(from: date)
        
        let realm = try! Realm()
        
        let objects = realm.objects(RecentStory.self)

        for object in objects {
            if object.id == self.story.id {
                try! realm.write {
                    realm.delete(object)
                }
                break
            }
        }
        
        
                let recentStory = RecentStory()
                recentStory.name = self.story.name
                recentStory.author = self.story.author
                
                for item in self.story.genre {
                    let recentGenre = RecentGenre()
                    recentGenre.id = item
                    recentStory.genre.append(recentGenre)
                }
                
                recentStory.id = self.story.id
                recentStory.numberOfChap = self.story.numberOfChap
                recentStory.thumbUrl = self.story.thumbUrl
                recentStory.rank = self.story.rank
                recentStory.chapterId = chapter.id
                recentStory.chapterName = chapter.name
        
                if let data = UIImagePNGRepresentation(story.image!) {
                    recentStory.dataImage = data as NSData
                }
        
                recentStory.date = Date() as NSDate
                recentStory.time = timeString
                
                do {
                    try realm.write {
                        realm.add(recentStory)
                    }
                    print("write completed")
                } catch {
                    print("error: \(error.localizedDescription)")
                }
            
        
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
    
    func requestData(completion: @escaping(_ check: Bool) -> Void) {
        
        let link = String(format: Constant.Request.requestChapter, self.chapter.id)
        
        DownloadManager.share.downloadDetailChapter(stringURL: link) { (images) in
            
            if images != nil {
                self.listImage = images!
                self.labelPageNumber.text = "\(self.pageNow + 1) - \(self.listImage.count)"
                self.collectionView.reloadData()
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    
    func tapScreen(){
        if isTapScreen {
            labelPageNumber.isHidden = true
            bottomBar.isHidden = true
            UIApplication.shared.isStatusBarHidden = true
            //viewBar.isHidden = true
            UIView.animate(withDuration: 0.5, animations: { 
                self.viewBar.isHidden = true
            })
            view.updateFocusIfNeeded()
            isTapScreen = !isTapScreen
        }else{
            UIApplication.shared.isStatusBarHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.viewBar.isHidden = false
            })
            labelPageNumber.isHidden = false
            bottomBar.isHidden = false
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
        
        self.saveBookmark(pageNow + 1)
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageNow = pageNumber
        self.labelPageNumber.text = "\(pageNumber + 1) - \(self.listImage.count)"
        
        if isShowingInitial == false {
            self.checkInitialBookmark(pageNow + 1)
        }
    }
    
    //SAVE IMAGE TO LIBRARY
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
    
    @IBAction func saveImage(_ sender: Any) {
        let indexPath = IndexPath(item: pageNow, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as! ReadStoryCell
        let image = cell.imageView.image
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func actionDownload(_ sender: Any) {
        
        self.buttonDownload.isHidden = true 
        
        DownloadManager.share.downloadOfflineStory(story: self.story, chapter: self.chapter, detailStory: self.detailStory)
                
    }
    
    
    @IBAction func actionBookmark(_ sender: Any) {

        if isBookmarked == true {
            self.buttonBookmark.setImage(#imageLiteral(resourceName: "bookmark2"), for: .normal)
            isBookmarked = false
        } else {
            self.buttonBookmark.setImage(#imageLiteral(resourceName: "bookmarked"), for: .normal)
            isBookmarked = true
        }

    }
    
    func checkInitialBookmark(_ pageCheck: Int) {
        
        self.initialBookmarked = false
        self.buttonBookmark.setImage(#imageLiteral(resourceName: "bookmark2"), for: .normal)
        self.isBookmarked = false
        
        let realm = try! Realm()
        
        let objects = realm.objects(BookmarkStory.self)
        
        for object in objects {
            if object.id == self.story.id {
                if object.chapterId == self.chapter.id {
                    if object.pageNumber == pageCheck {
                        self.initialBookmarked = true
                        self.isBookmarked = true
                        self.buttonBookmark.setImage(#imageLiteral(resourceName: "bookmarked"), for: .normal)
                        break
                    }
                }
            }
        }
        
    }
    
    func saveBookmark(_ pageCheck: Int) {
        
        let realm = try! Realm()
        
        if self.isBookmarked == true && self.initialBookmarked == false {

            let bookmarkStory = BookmarkStory()
            bookmarkStory.name = self.story.name
            bookmarkStory.author = self.story.author
            
            for item in self.story.genre {
                let bookmarkGenre = RealmGenre()
                bookmarkGenre.id = item
                bookmarkStory.genre.append(bookmarkGenre)
            }
            
            bookmarkStory.id = self.story.id
            bookmarkStory.numberOfChap = self.story.numberOfChap
            bookmarkStory.thumbUrl = self.story.thumbUrl
            bookmarkStory.rank = self.story.rank
            bookmarkStory.chapterId = chapter.id
            bookmarkStory.chapterName = chapter.name
            
            if let data = UIImagePNGRepresentation(story.image!) {
                bookmarkStory.dataImage = data as NSData
            }
            
            bookmarkStory.pageNumber = pageCheck
            
            do {
                try realm.write {
                    realm.add(bookmarkStory)
                }
                print("write completed")
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
        else if self.isBookmarked == false && self.initialBookmarked == true {
            
            let objects = realm.objects(BookmarkStory.self)
            
            for object in objects {
                if object.id == self.story.id && object.chapterId == self.chapter.id && object.pageNumber == pageCheck {
                    try! realm.write {
                        realm.delete(object)
                    }
                    break
                }
            }
            
        }
        
        
    }
    
    
}


extension ReadStoryViewController: UICollectionViewDelegate {
    // begin
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let url = URL(string: listImage[indexPath.item].link)
        (cell as! ReadStoryCell).imageView.kf.setImage(with: url)
        
        isShowingInitial = false
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
        
        if cell.doubleTap != nil {
            self.tapGesture.require(toFail: cell.doubleTap)
        }
        
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








