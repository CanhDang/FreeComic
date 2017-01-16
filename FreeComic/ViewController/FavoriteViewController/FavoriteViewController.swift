//
//  FavoriteViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
  
    var favoriteStories = [FavoriteStory]()
    
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: Constant.FavoriteVC.NibName.collectionViewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.FavoriteVC.Identifier.collectionViewCell)
        
        if revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestData()
    }
    
    func requestData() {
        favoriteStories = []
        
        realm = try! Realm()
        
        let objects = realm.objects(FavoriteStory.self)
        for object in objects {
            favoriteStories.append(object)
        }
        self.collectionView.reloadData()
    }
    

    @IBAction func actionOpenMenu(_ sender: Any) {
        if revealViewController() != nil {
            revealViewController().revealToggle(animated: true)
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
    }


}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.FavoriteVC.Identifier.collectionViewCell, for: indexPath) as! FavoriteCollectionCell
        
        cell.configure(favoriteStory: favoriteStories[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fvStory = favoriteStories[indexPath.item]
        var genre = [String]()
        for item in fvStory.genre {
            genre.append(item.id)
        }
        let story = Story(id: fvStory.id, name: fvStory.name, genre: genre, author: fvStory.author, thumbUrl: fvStory.thumbUrl, numberOfChap: fvStory.numberOfChap, rank: fvStory.rank)
        
        let detailStoryVC = DetailStoryViewController()
        detailStoryVC.story = story
        self.navigationController?.pushViewController(detailStoryVC, animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout{
    
}
