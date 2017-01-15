//
//  BookmarkStory.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGenre: Object {
    dynamic var id: String = ""
}

class BookmarkStory: Object {
    dynamic var id = ""
    dynamic var name: String = ""
    dynamic var author: String = ""
    dynamic var thumbUrl: String = ""
    dynamic var numberOfChap: String = ""
    dynamic var rank: String = ""
    dynamic var dataImage: NSData? = nil
    dynamic var chapterId: String = ""
    dynamic var chapterName: String = ""
    dynamic var pageNumber: Int = -1
    
    let genre = List<RealmGenre>()
}
