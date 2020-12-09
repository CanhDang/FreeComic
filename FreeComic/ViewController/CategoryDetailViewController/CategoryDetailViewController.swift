//
//  HomeViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Reachability

class CategoryDetailViewController: UIViewController {
    
    @IBOutlet weak var barName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tapOutSearchBar: UIGestureRecognizer!
    
    var stories = [Story]()
    
    var allStories = [Story]()
    
    var allStoriesSort = [Story]()
    
    var genreID = String()
    
    var genreName = String()
    
    let reachability = try! Reachability()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add pan gesture open menu
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        // Setup TableView
        let nib = UINib(nibName: Constant.HomeVC.NibName.homeTableViewCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Constant.HomeVC.Identifier.tableViewCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.barName.text = self.genreName.capitalized
        
        // Setup SearchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Constant.Color.blueColor.cgColor
        searchBar.delegate = self
        
        UISearchBar.appearance().tintColor = UIColor.white
        
        // Request Data
        self.requestData(Constant.Request.requestAll)
        
        try! reachability.startNotifier()

    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    
    func requestData(_ link: String) {
        
        reachability.whenReachable = { reachability in
            
            DispatchQueue.main.async {
                let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
                loading.mode = .indeterminate
                loading.label.text = "Loading"
            }
            
            if link == Constant.Request.requestNew {
                
                DownloadManager.share.downloadNew(stringURL: link, completion: { (newStories) in
                    self.allStories = newStories.sorted(by: { (a, b) -> Bool in
                        a.name < b.name
                    })
                    self.stories = self.allStories
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.tableView.reloadData()
                    }
                })
                
            } else {
                DownloadManager.share.downloadAllOrTop(stringURL: link) { (allStories) in
                    for story in allStories {
                        for gen in story.genre {
                            if ( gen == self.genreID) {
                                self.allStories.append(story)
                            }
                        }
                    }
                    self.allStoriesSort = self.allStories.sorted(by: { (a, b) -> Bool in
                        a.name < b.name
                    })
                    self.stories = self.allStoriesSort
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            self.showAlert(title: Constant.HomeVC.String.Alert, message: Constant.HomeVC.String.NoInternetConnection)
            
        }
        
    }
    
    @IBAction func actionOpenMenu(_ sender: AnyObject) {
        
        self.endSearchBar()
        
        //        if revealViewController() != nil {
        //            revealViewController().revealToggle(self)
        //        }
        
        self.navigationController!.popViewController(animated: true)
        
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: Constant.HomeVC.String.OK, style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.HomeVC.Identifier.tableViewCell, for: indexPath) as! HomeTableViewCell
        
        cell.configure(story: self.stories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailStoryVC = DetailStoryViewController()
        detailStoryVC.story = self.stories[indexPath.row]
        self.navigationController?.pushViewController(detailStoryVC, animated: true)
        self.endSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ok")
        self.endSearchBar()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder == true {
            searchBar.resignFirstResponder()
        }
    }
    
}

extension CategoryDetailViewController: UISearchBarDelegate {
    
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
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.stories = []
        for story in self.allStories {
            if story.name.contains(searchText) {
                self.stories.append(story)
            }
        }
        self.tableView.reloadData()
    }
}


