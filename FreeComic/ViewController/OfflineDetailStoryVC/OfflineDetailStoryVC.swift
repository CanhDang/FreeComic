//
//  OfflineDetailStoryVC.swift
//  FreeComic
//
//  Created by Enrik on 2/13/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import RealmSwift

class OfflineDetailStoryVC: UIViewController {

    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var thumbView: UIImageView!

    @IBOutlet weak var labelStoryName: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelNumberChapters: UILabel!
    
    @IBOutlet weak var buttonFavorite: UIButton!
    
    @IBOutlet weak var buttonShowDescription: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak internal var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak internal var topTableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var offlineStory: OfflineStory!

    let tableCellIdentifier = "OfflineTableCell"

    var listChapters = [OfflineChapter]()
    
    var tapOutSearchBar: UITapGestureRecognizer!
    
    var isShowingDescription = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        self.setupDetailView()
        
        // Setup Table View
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        let nib = UINib(nibName: Constant.DetailVC.NibName.detailTableViewCell, bundle: nil)
        self.detailTableView.register(nib, forCellReuseIdentifier: tableCellIdentifier)
        
        viewSearch.layer.borderWidth = 1
        viewSearch.layer.borderColor = Constant.Color.blueColor.cgColor
        
        addDoneButtonToKeyboard(myAction: #selector(actionSearch))
        
        // Description
        self.textViewDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.buttonShowDescription.addTarget(self, action: #selector(actionShowDescription), for: .touchUpInside)
        
        // Request Data
        self.listChapters = []
        for chapter in self.offlineStory.chapters {
            self.listChapters.append(chapter)
        }
        self.listChapters.sort { (a, b) -> Bool in
            a.chapterName < b.chapterName
        }
        detailTableView.reloadData()
    }
    
    func setupDetailView(){
        
        self.labelTitle.text = self.offlineStory.name
        
        self.labelStoryName.text = self.offlineStory.name
        self.labelAuthor.text = self.offlineStory.author
        
        let numberOfChapters = self.offlineStory.chapters.count
        
        self.labelNumberChapters.text = String(numberOfChapters) + " / " + self.offlineStory.numberOfChap + " chapters"
        
        if let dataImage = self.offlineStory.dataThumb {
            let image = UIImage(data: dataImage as Data)
            self.thumbView.image = image
        }
        
        self.textViewDescription.text = self.offlineStory.summary
    }
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.barTintColor = UIColor.lightGray
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }

    @objc func actionSearch() {
        if let searchText = searchBar.text {
            for (index,chapter) in listChapters.enumerated() {
                if chapter.chapterName.contains(searchText) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    break
                }
            }
            if let number = Int(searchText) {
                if number > listChapters.count{
                    let indexPath = IndexPath(row: listChapters.count - 1 , section: 0)
                    self.detailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func actionShowDescription() {
        
        self.buttonShowDescription.isEnabled = false
        
        if isShowingDescription {
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonShowDescription.setImage(UIImage(named: "Show"), for: .normal)
                self.textViewHeightConstraint.constant = 0
                self.topTableViewConstraint.constant = 0
                self.view.layoutSubviews()
                
            }, completion: { (completed) in
                self.isShowingDescription = false
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
                self.isShowingDescription = true
                self.buttonShowDescription.isEnabled = true
            })
        }

        
    }
}

extension OfflineDetailStoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listChapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableCellIdentifier, for: indexPath) as! DetailTableViewCell
        cell.labelChapterName.text = listChapters[indexPath.row].chapterName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = listChapters[indexPath.row]
        
        let readOfflineStoryVC = ReadOfflineStoryVC()
        readOfflineStoryVC.chapter = chapter
        readOfflineStoryVC.offlineStory = self.offlineStory
        self.navigationController!.pushViewController(readOfflineStoryVC, animated: true)
    }
}

extension OfflineDetailStoryVC: UISearchBarDelegate {
    @objc func endSearchBar() {
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

