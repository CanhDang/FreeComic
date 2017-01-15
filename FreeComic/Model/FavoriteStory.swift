//
//  FavoriteStory.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteGenre: Object {
    dynamic var id: String = ""
}

class FavoriteStory: Object {
    dynamic var id = ""
    dynamic var name: String = ""
    dynamic var author: String = ""
    dynamic var thumbUrl: String = ""
    dynamic var numberOfChap: String = ""
    dynamic var rank: String = ""
    dynamic var dataImage = NSData()
    let genre = List<FavoriteGenre>()
}
