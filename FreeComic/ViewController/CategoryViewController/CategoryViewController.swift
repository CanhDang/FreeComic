//
//  CategoryViewController.swift
//  FreeComic
//
//  Created by Hoang Doan on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.configure(category: Constant.category[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.categoryTable.frame.width / 3
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        self.categoryTable.register(nib, forCellReuseIdentifier: "CategoryCell")
        
        self.categoryTable.delegate = self
        self.categoryTable.dataSource = self
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
