//
//  HomeViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import ReachabilitySwift

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Add pan gesture open menu
        if revealViewController() != nil {
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        // Setup TableView
        let nib = UINib(nibName: Constant.HomeVC.NibName.homeTableViewCell, bundle: nil)
        self.homeTableView.register(nib, forCellReuseIdentifier: Constant.HomeVC.Identifier.tableViewCell)
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self 
        
        // Segment Control
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
        // Setup SearchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Constant.Color.blueColor.cgColor
        searchBar.delegate = self
//        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
//        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)

        UISearchBar.appearance().tintColor = UIColor.white
        
        // Request Data
        self.requestData()
        
    }
    
    func requestData() {
        
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text = "Loading"
        
        DownloadManager.share.downloadAllOrTop(stringURL: Constant.Request.requestAll) { (allStories) in
            self.allStories = allStories.sorted(by: { (a, b) -> Bool in
                a.name < b.name
            })
            self.stories = self.allStories
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.homeTableView.reloadData()
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
        case 1:
            break
        case 2:
            break
        default:
            break
        }
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


