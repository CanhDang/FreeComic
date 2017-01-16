//
//  BookmarkViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var labelInitial: UILabel!
    
    var bookmarkStories = [BookmarkStory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self 

        if revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        let nib = UINib(nibName: Constant.BookmarkVC.NibName.tableViewCell, bundle: nil)
        
        bookmarkTableView.register(nib, forCellReuseIdentifier: Constant.BookmarkVC.Identifier.tableViewCell)
        
        bookmarkTableView.tableFooterView = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelInitial.isHidden = false
        bookmarkTableView.isHidden = true
        requestData()
    }
    
    func requestData() {
        bookmarkStories = []
        
        let realm = try! Realm()
        
        let objects = realm.objects(BookmarkStory.self)
        
        for object in objects {
            bookmarkStories.append(object)
        }
        if bookmarkStories.count > 0 {
            self.bookmarkTableView.isHidden = false
            self.labelInitial.isHidden = true
        }
        self.bookmarkTableView.reloadData()
    }
    
    
    @IBAction func actioinOpenMenu(_ sender: Any) {
        if revealViewController() != nil {
            revealViewController().revealToggle(animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.BookmarkVC.Identifier.tableViewCell, for: indexPath) as! BookmarkTableCell
        
        cell.configure(bookmarkStory: bookmarkStories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bkStory = self.bookmarkStories[indexPath.row]
        
        var genre = [String]()
        
        for item in bkStory.genre {
            genre.append(item.id)
        }
        
        let story = Story(id: bkStory.id, name: bkStory.name, genre: genre, author: bkStory.author, thumbUrl: bkStory.thumbUrl, numberOfChap: bkStory.numberOfChap, rank: bkStory.rank)
        if bkStory.dataImage != nil {
            story.image = UIImage(data: bkStory.dataImage as! Data)
        }
        let readStoryVC = ReadStoryViewController()
        readStoryVC.story = story
        readStoryVC.chapter = Chapter(name: bkStory.chapterName, id: bkStory.chapterId)
        readStoryVC.pageToScroll = bkStory.pageNumber - 1
        self.navigationController?.pushViewController(readStoryVC, animated: true)
    }
    
    
}






