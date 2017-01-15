//
//  RecentTableCell.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class RecentTableCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelNumberChapter: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(_ recentStory: RecentStory) {
        if let data = recentStory.dataImage {
            self.thumbView.image = UIImage(data: data as Data)
        } else {
            let url = URL(string: "http://" + recentStory.thumbUrl)
            self.thumbView.kf.setImage(with: url, placeholder: UIImage(named: "no_thumbnail"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.labelName.text = recentStory.name
        self.labelAuthor.text = recentStory.author
        self.labelNumberChapter.text = recentStory.chapterName
        self.labelTime.text = recentStory.time
  
    }
}
