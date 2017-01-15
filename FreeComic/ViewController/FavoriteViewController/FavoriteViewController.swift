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
    
    var stories = [FavoriteStory]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "FavoriteCollectionCell", bundle: nil)
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
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
