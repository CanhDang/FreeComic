//
//  MenuViewController.swift
//  FreeComic
//
//  Created by Enrik on 1/7/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: Constant.MenuVC.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constant.MenuVC.cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.MenuVC.numberOfContent
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.MenuVC.cellIdentifier, for: indexPath) as! MenuTableCell
        
        switch  indexPath.row {
        case Constant.MenuVC.CellNumber.category:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.category)
            cell.title.text = Constant.MenuVC.CellName.category
        case Constant.MenuVC.CellNumber.favorites:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.favorites)
            cell.title.text = Constant.MenuVC.CellName.favorites
        case Constant.MenuVC.CellNumber.library:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.library)
            cell.title.text = Constant.MenuVC.CellName.library
        case Constant.MenuVC.CellNumber.bookmark:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.bookmark)
            cell.title.text = Constant.MenuVC.CellName.bookmark
        case Constant.MenuVC.CellNumber.recent:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.recent)
            cell.title.text = Constant.MenuVC.CellName.recent
        default:
            cell.logo.image = UIImage(named: Constant.MenuVC.CellName.home)
            cell.title.text = Constant.MenuVC.CellName.home
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case Constant.MenuVC.CellNumber.category:
            let categoryVC = CategoryViewController()
            revealViewController().pushFrontViewController(categoryVC, animated: true)
        case Constant.MenuVC.CellNumber.favorites:
            let favoriteVC = FavoriteViewController()
            revealViewController().pushFrontViewController(favoriteVC, animated: true)
        default:
            let homeVC = HomeViewController()
            revealViewController().pushFrontViewController(homeVC, animated: true)
        }
    }
    
}


