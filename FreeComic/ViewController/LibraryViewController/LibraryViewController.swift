//
//  LibraryViewController.swift
//  FreeComic
//
//  Created by Enrik on 2/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import RealmSwift

class LibraryViewController: UIViewController {

    @IBOutlet weak var libraryTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var allStories = [OfflineStory]()
    var stories = [OfflineStory]()
    
    let identifier = "LibraryTableViewCell"
    let stringDelete = "DELETE"
    
    var tapOutSearchBar: UIGestureRecognizer!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add pan gesture open menu
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        // Setup TableView
        let nib = UINib(nibName: Constant.HomeVC.NibName.homeTableViewCell, bundle: nil)
        self.libraryTableView.register(nib, forCellReuseIdentifier: self.identifier)
        self.libraryTableView.delegate = self
        self.libraryTableView.dataSource = self

        
        // Setup SearchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Constant.Color.blueColor.cgColor
        searchBar.delegate = self
        
        UISearchBar.appearance().tintColor = UIColor.white
        
        // Request Data
        self.requestData()
        
        // Pull to refresh
        self.libraryTableView.addSubview(self.refreshControl)
    }
    
    // Refresh Table View
    func handleRefresh(refreshControl: UIRefreshControl) {
        let realm = try! Realm()
        
        let objects = realm.objects(OfflineStory.self)
        
        self.allStories = []
        self.stories = []
        for object in objects {
            self.allStories.append(object)
        }
        self.stories = self.allStories
        
        self.libraryTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func actionOpenMenu(_ sender: Any) {
        
        if revealViewController() != nil {
            revealViewController().revealToggle(animated: true)
        }
    }
    
    func requestData() {
        let realm = try! Realm()
        
        let objects = realm.objects(OfflineStory.self)
        
        self.allStories = []
        self.stories = []
        for object in objects {
            self.allStories.append(object)
        }
        self.stories = self.allStories
        self.libraryTableView.reloadData()
        
    }
    
}

// MARK: UITableViewDelegate + DataSource
extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as! HomeTableViewCell
        
        let offlineStory = stories[indexPath.row]
        
        var genre: [String] = []
        
        for genreItem in offlineStory.genres {
            genre.append(genreItem.id)
        }
        cell.configureOffline(offlineStory: offlineStory)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let offlineStory = stories[indexPath.row]
        
        let offlineDetailStoryVC = OfflineDetailStoryVC()
        offlineDetailStoryVC.offlineStory = offlineStory
        self.navigationController?.pushViewController(offlineDetailStoryVC, animated: true)
        
        self.endSearchBar()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder == true {
            searchBar.resignFirstResponder()
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .destructive, title: stringDelete) { (action, indexPath) in
            
            self.deleteStory(self.allStories[indexPath.row], indexPath: indexPath)
            self.requestData()
            
        }
        return [edit]
    }
    
    func deleteStory(_ story: OfflineStory, indexPath: IndexPath) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(story)
        }
    }
}


// MARK: Search
extension LibraryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ok")
        self.endSearchBar()
    }
    
    func endSearchBar() {
        if self.searchBar.isFirstResponder == true {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //tapOutSearchBar = UITapGestureRecognizer(target: self, action: #selector(endSearchBar))
        //self.view.addGestureRecognizer(tapOutSearchBar)
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.view.removeGestureRecognizer(tapOutSearchBar)
        
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = nil
        self.endSearchBar()
        self.stories = []
        self.stories = self.allStories
        self.libraryTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.stories = []
        for story in self.allStories {
            if story.name.contains(searchText) {
                self.stories.append(story)
            }
        }
        self.libraryTableView.reloadData()
    }

    
}



