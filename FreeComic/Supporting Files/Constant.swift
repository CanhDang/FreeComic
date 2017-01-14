//
//  Constant.swift
//  FreeComic
//
//  Created by Enrik on 1/8/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

struct Constant {
    
    static let category = [
        "1":"action",
        "2": "adventure",
        "3": "comedy",
        "15": "drama",
        "4": "fantasy",
        "8": "horror",
        "31": "manhua",
        "47": "martial arts",
        "10": "mystery",
        "22": "romance",
        "26": "school life",
        "27": "shoujo",
        "5": "shounen",
        "17": "slice of life",
        "6": "supernatural"
    ]
    
    struct Request {
        static let requestAll = "http://stage.yennhidesign.com/source1n.json"
        static let requestTop = "http://stage.yennhidesign.com/source1r.json"
        static let requestNew = "http://stage.yennhidesign.com/update1.json"
        static let requestDetailStory = "http://stage.yennhidesign.com/manga%@.json"
        static let requestChapter = "http://stage.yennhidesign.com/chapter%@.json"
    }
    
    struct Color {
        static let blueColor = UIColor(red:0.00, green:0.48, blue:0.53, alpha:1.0)
    }

    struct MenuVC {
        static let numberOfContent = 6
        static let cellIdentifier = "MenuTableCell"
        
        struct CellName {
            static let home = "Home"
            static let category = "Categories"
            static let favorites = "Favorites"
            static let library = "Library"
            static let bookmark = "Bookmarks"
            static let recent = "Recents"
        }
        
        struct CellNumber {
            static let home = 0
            static let category = 1
            static let favorites = 2
            static let library =  3
            static let bookmark = 4
            static let recent = 5
        }
    }
    
    struct HomeVC {
        struct Identifier {
            static let tableViewCell = "HomeTableViewCell"
        }
        
        struct NibName {
            static let homeTableViewCell = "HomeTableViewCell"
        }
        
        struct String {
            static let OK = "OK"
            static let Alert = "Alert"
            static let NoInternetConnection = "No Internet Connection"
        }
        
        struct Segment {
            static let all = 0
            static let top = 1
            static let new = 2 
        }
    }
    
    struct DetailVC {
        struct Identifier {
            static let detailTableViewCell = "DetailTableViewCell"
        }
        struct NibName {
            static let detailTableViewCell = "DetailTableViewCell"
        }
        
    }
    
    struct ReadStoryVC {
        struct Identifier {
            static let collectionViewCell = "ReadStoryCell"
        }
        struct NibName {
            static let collectionViewCell = "ReadStoryCell"
        }
    }
}
