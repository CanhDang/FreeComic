//
//  DetailStoryViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/9/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

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
    
    var tapOutSearchBar: UIGestureRecognizer!
    
    var story: Story!
    var detailStory: DetailStory!
    var chapters = [Chapter]()
    
    var isShowingDesciption: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.setupDetailView()
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        let nib = UINib(nibName: Constant.DetailVC.NibName.detailTableViewCell, bundle: nil)
        self.detailTableView.register(nib, forCellReuseIdentifier: Constant.DetailVC.Identifier.detailTableViewCell)
        
        viewSearch.layer.borderWidth = 1
        viewSearch.layer.borderColor = Constant.Color.blueColor.cgColor
        
        addDoneButtonToKeyboard(myAction: #selector(actionSearch))
        
        requestLink()
    }
    
    
    func requestLink() {
        
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text = "Loading"
        
        let linkString = String(format: Constant.Request.requestDetailStory, self.story.id)
        print(linkString)
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
    
    func setupDetailView() {
        self.labelTitle.text = self.story.name
        self.labelName.text = self.story.name
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
                self.view.layoutSubviews()
                
            }, completion: { (completed) in
                self.isShowingDesciption = false
                self.buttonShowDescription.isEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonShowDescription.setImage(UIImage(named: "Dismiss"), for: .normal)
                self.textViewHeightConstraint.constant = self.viewSearch.frame.height + self.detailTableView.frame.height / 2
                self.view.layoutSubviews()
            }, completion: { (completed) in
                self.isShowingDesciption = true
                self.buttonShowDescription.isEnabled = true 
            })
        }
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
        readStoryVC.chapter = self.chapters[indexPath.row]
        
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

