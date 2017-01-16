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
    
    @IBOutlet weak var labelInitial: UILabel!

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
        
        self.recentTableView.tableFooterView = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.labelInitial.text = "NO RECENT ADDED"
        self.labelInitial.isHidden = false
        self.recentTableView.isHidden = true
        
        requestData()
    }
    
    func requestData() {
        recentStories = []
        let realm = try! Realm()
        
        let objects = realm.objects(RecentStory.self)
        
        for object in objects {
            recentStories.append(object)
        }
        recentStories.sort { (a, b) -> Bool in
            (a.date as Date) > (b.date as Date)
        }
        if recentStories.count > 0 {
            self.labelInitial.isHidden = true 
            self.recentTableView.isHidden = false
            recentTableView.reloadData()
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reStory = recentStories[indexPath.item]
        var genre = [String]()
        for item in reStory.genre {
            genre.append(item.id)
        }
        let story = Story(id: reStory.id, name: reStory.name, genre: genre, author: reStory.author, thumbUrl: reStory.thumbUrl, numberOfChap: reStory.thumbUrl, rank: reStory.rank)
        
        let detailStoryVC = DetailStoryViewController()
        detailStoryVC.story = story
        self.navigationController?.pushViewController(detailStoryVC, animated: true)
    }
}



