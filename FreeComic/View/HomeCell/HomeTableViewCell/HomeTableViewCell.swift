//
//  HomeTableViewCell.swift
//  FreeComic
//
//  Created by Enrik on 1/9/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelNumberChapter: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(story: Story) {
        
        let url = URL(string: "http://" + story.thumbUrl)
        
        self.thumbnail.kf.setImage(with: url, placeholder: UIImage(named: "no_thumbnail"), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        self.labelName.text = story.name.uppercased()
        self.labelAuthor.text = story.author
        self.labelNumberChapter.text = story.numberOfChap + " chapters"
    }
    
}
