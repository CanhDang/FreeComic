//
//  BookmarkTableCell.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class BookmarkTableCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelNumberChapter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(bookmarkStory: BookmarkStory) {
        if let data = bookmarkStory.dataImage {
            self.thumbView.image = UIImage(data: data as Data)
        } else {
            let url = URL(string: "http://" + bookmarkStory.thumbUrl)
            self.thumbView.kf.setImage(with: url, placeholder: UIImage(named: "no_thumbnail"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.labelName.text = bookmarkStory.name
        self.labelAuthor.text = "Chapter: " + bookmarkStory.chapterName
        self.labelNumberChapter.text = "Page: \(bookmarkStory.pageNumber+1)"
        
    }
    
}
