//
//  HomeViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Reachability

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tapOutSearchBar: UIGestureRecognizer!
    
    var stories = [Story]()
    
    var allStories = [Story]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var link : String!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    var cache: NSCache<NSString, CacheStories>!
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Cache
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.cache = appDelegate.cache

        // Add pan gesture open menu
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        // Setup TableView
        let nib = UINib(nibName: Constant.HomeVC.NibName.homeTableViewCell, bundle: nil)
        self.homeTableView.register(nib, forCellReuseIdentifier: Constant.HomeVC.Identifier.tableViewCell)
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        // Segment Control
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red:0.00, green:0.48, blue:0.53, alpha:1.0)], for: .selected)
        
        // Setup SearchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Constant.Color.blueColor.cgColor
        searchBar.delegate = self
        
        UISearchBar.appearance().tintColor = UIColor.white
        
        // Request Data
        self.link = Constant.Request.requestAll
        self.requestData(Constant.Request.requestAll)
        
        // Pull to refresh
        self.homeTableView.addSubview(self.refreshControl)
        
         try! reachability.startNotifier()
    }
    
    // Refresh Table View
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
                
        reachability.whenReachable = { reachability in
            
            if self.link == Constant.Request.requestNew {
                
                DownloadManager.share.downloadNew(stringURL: self.link, completion: { (newStories) in
                    self.allStories = newStories.sorted(by: { (a, b) -> Bool in
                        a.name < b.name
                    })
                    self.stories = self.allStories
                    
                    let cacheStories = CacheStories(stories: self.allStories)
                    self.cache.setObject(cacheStories, forKey: self.link as NSString)
                    
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                })
                
            } else {
                DownloadManager.share.downloadAllOrTop(stringURL: self.link) { (allStories) in
                    self.allStories = allStories.sorted(by: { (a, b) -> Bool in
                        a.name < b.name
                    })
                    self.stories = self.allStories
                    
                    let cacheStories = CacheStories(stories: self.allStories)
                    self.cache.setObject(cacheStories, forKey: self.link as NSString)
                    
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            self.showAlert(title: Constant.HomeVC.String.Alert, message: Constant.HomeVC.String.NoInternetConnection)
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    func requestData(_ link: String) {
        
        if let cachedVersion = cache.object(forKey: link as NSString) {
            
            self.allStories = cachedVersion.stories
            self.stories = self.allStories
            self.homeTableView.reloadData()
            
        } else {
                    
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
                        
                        let cacheStories = CacheStories(stories: self.allStories)
                        self.cache.setObject(cacheStories, forKey: link as NSString)
                        
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.homeTableView.reloadData()
                        }
                    })
                    
                } else {
                    DownloadManager.share.downloadAllOrTop(stringURL: link) { (allStories) in
                        self.allStories = allStories.sorted(by: { (a, b) -> Bool in
                            a.name < b.name
                        })
                        self.stories = self.allStories
                        print("self.stories.count", self.stories.count)
                        let cacheStories = CacheStories(stories: self.allStories)
                        self.cache.setObject(cacheStories, forKey: link as NSString)
                        
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.homeTableView.reloadData()
                        }
                    }
                }
            }
            
            reachability.whenUnreachable = { reachability in
                self.showAlert(title: Constant.HomeVC.String.Alert, message: Constant.HomeVC.String.NoInternetConnection)
                
            }
            
        }
        
        
        
    }
    
    
    
    @IBAction func actionOpenMenu(_ sender: AnyObject) {
        
        self.endSearchBar()
        
        if revealViewController() != nil {
            revealViewController().revealToggle(self)
        }
    }
    
    @IBAction func actionSegment(_ sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
        case Constant.HomeVC.Segment.top:
            self.endSearchBar()
            self.link = Constant.Request.requestTop
            self.requestData(Constant.Request.requestTop)
        case Constant.HomeVC.Segment.new:
            self.endSearchBar()
            self.link = Constant.Request.requestNew
            self.requestData(Constant.Request.requestNew)
        default:
            self.endSearchBar()
            self.link = Constant.Request.requestAll
            self.requestData(Constant.Request.requestAll)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: Constant.HomeVC.String.OK, style: .default, handler: nil)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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

extension HomeViewController: UISearchBarDelegate {
    
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
        self.homeTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.stories = []
        for story in self.allStories {
            if story.name.contains(searchText) {
                self.stories.append(story)
            }
        }
        self.homeTableView.reloadData()
    }
}


