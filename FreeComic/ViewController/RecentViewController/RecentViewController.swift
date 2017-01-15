//
//  RecentViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import RealmSwift

class RecentViewController: UIViewController {

    @IBOutlet weak var recentTableView: UITableView!
    
    var recentStories = [RecentStory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        recentTableView.delegate = self
        recentTableView.dataSource = self
        let nib = UINib(nibName: Constant.RecentVC.NibName.tableViewCell, bundle: nil)
        recentTableView.register(nib, forCellReuseIdentifier: Constant.RecentVC.Identifier.tableViewCell)
        
        requestData()
    }
    
    func requestData() {
        recentStories = []
        let realm = try! Realm()
        
        let objects = realm.objects(RecentStory.self)
        
        for object in objects {
            recentStories.append(object)
        }
        recentStories.reverse()
        recentTableView.reloadData()
    }

    @IBAction func actionOpenMenu(_ sender: Any) {
        
        if revealViewController() != nil {
            revealViewController().revealToggle(animated: true)
        }
        
    }

}
extension RecentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.RecentVC.Identifier.tableViewCell, for: indexPath) as! RecentTableCell
        
        cell.configure(recentStories[indexPath.row])
        
        return cell
    }
}



