//
//  MenuTableCell.swift
//  FreeComic
//
//  Created by Enrik on 1/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {

    
    @IBOutlet weak var logo: UIImageView!
   
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bgColorView = UIView()
        bgColorView.backgroundColor = Constant.Color.blueColor
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
