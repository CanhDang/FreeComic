//
//  CategoryCell.swift
//  FreeComic
//
//  Created by Hoang Doan on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryCover: UIImageView!
    
    var cellID:Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(category: Category) {
        self.categoryCover.image = UIImage(named: category.name)
        print(category.name)
        self.cellID = category.id        
    }
    
}
