//
//  DetailStoryViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/9/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Reachability
import RealmSwift

class DetailStoryViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var imageThumb: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelNumberOfChapters: UILabel!
    
    @IBOutlet weak var buttonFavorite: UIButton!

    @IBOutlet weak var buttonShowDescription: UIButton!
    
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    
    var realm: Realm!
    
    var tapOutSearchBar: UIGestureRecognizer!
    
    var story: Story!
    var detailStory: DetailStory!
    var chapters = [Chapter]()
    
    var isShowingDesciption: Bool = false
    var isFavorited: Bool = false
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        searchBar.delegate = self
        
        self.setupDetailView()
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        let nib = UINib(nibName: Constant.DetailVC.NibName.detailTableViewCell, bundle: nil)
        self.detailTableView.register(nib, forCellReuseIdentifier: Constant.DetailVC.Identifier.detailTableViewCell)
        
        viewSearch.layer.borderWidth = 1
        viewSearch.layer.borderColor = Constant.Color.blueColor.cgColor
        
        addDoneButtonToKeyboard(myAction: #selector(actionSearch))
        self.textViewDescription.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        
        checkFavorite()
        
        requestLink(Constant.Request.requestDetailStory)
        
        // SWIPE GESTURE
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.navigationController!.popViewController(animated: true)
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func checkFavorite() {

        let objects = realm.objects(FavoriteStory.self)
        for object in objects {
            if object.id == story.id {
                story.isFavorited = true
                self.isFavorited = true
                buttonFavorite.setImage(#imageLiteral(resourceName: "Star_filled"), for: .normal)
                break
            }
        }
    }
    
    func requestLink(_ link: String) {
        
        let reachability = Reachability()
        
        reachability?.whenReachable = { reachability in
        
            DispatchQueue.main.async {
                let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
                loading.mode = .indeterminate
                loading.label.text = "Loading"
            }
        
        let linkString = String(format: link, self.story.id)
        
        DownloadManager.share.downloadDetailStory(stringURL: linkString) { (detailStory) in
            if detailStory != nil {
                self.detailStory = detailStory
                self.chapters = (detailStory?.chapters)!
                
                self.textViewDescription.text = detailStory?.summary
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.detailTableView.reloadData()
                }
            }
        }
            
        }
        
        reachability?.whenUnreachable = { reachability in
            self.showAlert(title: Constant.HomeVC.String.Alert, message: Constant.HomeVC.String.NoInternetConnection)
            
        }
        
        try! reachability?.startNotifier()
    }
    
    func setupDetailView() {
        self.labelTitle.text = self.story.name.uppercased()
        self.labelName.text = self.story.name.uppercased()
        self.labelAuthor.text = self.story.author
        self.labelNumberOfChapters.text = self.story.numberOfChap + " chapters"
        let url = URL(string: "http://" + story.thumbUrl)
        self.imageThumb.kf.setImage(with: url, placeholder: UIImage(named: "no_thumbnail"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @IBAction func actionBack(_ sender: AnyObject) {
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.barTintColor = UIColor.lightGray
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        searchBar.inputAccessoryView = doneToolbar
    }

    func actionSearch() {
        
        if let searchText = searchBar.text {
            for (index,chapter) in chapters.enumerated() {
                if chapter.name.contains(searchText) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    break 
                }
            }
            if let number = Int(searchText) {
                if number > chapters.count{
                    let indexPath = IndexPath(row: chapters.count - 1 , section: 0)
                    self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    

    func saveStateFavorite() {
        
        if self.isFavorited == true && self.story.isFavorited == false {
            let favoriteStory = FavoriteStory()
            favoriteStory.name = self.story.name
            favoriteStory.author = self.story.author
            
            for item in self.story.genre {
                let favoriteGenre = FavoriteGenre()
                favoriteGenre.id = item
                favoriteStory.genre.append(favoriteGenre)
            }
            
            favoriteStory.id = self.story.id
            favoriteStory.numberOfChap = self.story.numberOfChap
            favoriteStory.thumbUrl = self.story.thumbUrl
            favoriteStory.rank = self.story.rank
            
            if let data = UIImagePNGRepresentation(imageThumb.image!) {
                favoriteStory.dataImage = data as NSData
            }

            do {
                try self.realm.write {
                    self.realm.add(favoriteStory)
                }
                print("write completed")
            } catch {
                print("error: \(error.localizedDescription)")
            }
  
        } else if self.isFavorited == false && self.story.isFavorited == true {
            
            let objects = realm.objects(FavoriteStory.self)
            for object in objects {
                if object.id == story.id {
                    try! self.realm.write {
                        self.realm.delete(object)
                    }
                    self.story.isFavorited = false 
                    break
                }
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        saveStateFavorite()
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        
        if self.isFavorited == true {
            self.isFavorited = false
            self.buttonFavorite.setImage(#imageLiteral(resourceName: "Star_not_filled"), for: .normal)
        } else {
            self.isFavorited = true
            self.buttonFavorite.setImage(#imageLiteral(resourceName: "Star_filled"), for: .normal)
        }
 
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isShowingDesciption {
            self.textViewHeightConstraint.constant = self.viewSearch.frame.height + self.detailTableView.frame.height / 2
        }
    }
    
    @IBAction func actionShowDescription(_ sender: Any) {
        
        self.buttonShowDescription.isEnabled = false
        
        if isShowingDesciption {
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonShowDescription.setImage(UIImage(named: "Show"), for: .normal)
                self.textViewHeightConstraint.constant = 0
                self.topTableViewConstraint.constant = 0
                self.view.layoutSubviews()
                
            }, completion: { (completed) in
                self.isShowingDesciption = false
                self.buttonShowDescription.isEnabled = true
            })
        } else {
            
            var height = textViewDescription.contentSize.height
            
            if height > detailTableView.frame.height/2 {
                height = detailTableView.frame.height/2
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonShowDescription.setImage(UIImage(named: "Dismiss"), for: .normal)

                self.textViewHeightConstraint.constant = height
                self.topTableViewConstraint.constant = height
                self.view.layoutSubviews()
            }, completion: { (completed) in
                self.isShowingDesciption = true
                self.buttonShowDescription.isEnabled = true 
            })
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: Constant.HomeVC.String.OK, style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DetailStoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.DetailVC.Identifier.detailTableViewCell, for: indexPath) as! DetailTableViewCell
        
        cell.labelChapterName.text = chapters[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readStoryVC = ReadStoryViewController()
        if imageThumb.image != nil {
            story.image = imageThumb.image
        }
        readStoryVC.chapter = self.chapters[indexPath.row]
        readStoryVC.story = self.story
        readStoryVC.detailStory = self.detailStory
        
        self.navigationController?.pushViewController(readStoryVC, animated: true)
    }
}

extension DetailStoryViewController: UISearchBarDelegate {
    
    func endSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tapOutSearchBar = UITapGestureRecognizer(target: self, action: #selector(endSearchBar))
        self.view.addGestureRecognizer(tapOutSearchBar)
        buttonFavorite.isEnabled = false
        buttonShowDescription.isEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.removeGestureRecognizer(tapOutSearchBar)
        buttonFavorite.isEnabled = true
        buttonShowDescription.isEnabled = true
    }
    
}

