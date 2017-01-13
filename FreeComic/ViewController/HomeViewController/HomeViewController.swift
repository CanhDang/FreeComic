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
    
    
    var stories = [Story]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: Constant.HomeVC.NibName.homeTableViewCell, bundle: nil)
        self.homeTableView.register(nib, forCellReuseIdentifier: Constant.HomeVC.Identifier.tableViewCell)
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self 
        
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Constant.Color.blueColor.cgColor
        
        DownloadManager.share.downloadAllOrTop(stringURL: Constant.Request.requestAll) { (allStories) in
            self.stories = allStories.sorted(by: { (a, b) -> Bool in
                a.name < b.name
            })
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
        
    }
    

    @IBAction func actionOpenMenu(_ sender: AnyObject) {
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
        
    }
}


