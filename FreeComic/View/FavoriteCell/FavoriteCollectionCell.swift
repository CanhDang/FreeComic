//
//  FavoriteCollectionCell.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Kingfisher

class FavoriteCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(favoriteStory: FavoriteStory) {
        if let data = favoriteStory.dataImage {
            self.thumbView.image = UIImage(data: data as Data)
        } else {
            let url = URL(string: "http://" + favoriteStory.thumbUrl)
            self.thumbView.kf.setImage(with: url, placeholder: UIImage(named: "no_thumbnail"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.labelName.text = favoriteStory.name
        self.labelAuthor.text = favoriteStory.author  
    }

}
