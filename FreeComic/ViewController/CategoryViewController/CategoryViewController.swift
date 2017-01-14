//
//  CategoryViewController.swift
//  FreeComic
//
//  Created by Hoang Doan on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionOpenMenu(_ sender: Any) {
        
        if revealViewController() != nil {
            revealViewController().revealToggle(animated: true)
        }
    }


}
