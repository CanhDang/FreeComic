//
//  RecentStory.swift
//  FreeComic
//
//  Created by Enrik on 1/15/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation
import RealmSwift

class RecentGenre: Object {
    dynamic var id: String = ""
}

class RecentStory: Object {
    dynamic var id = ""
    dynamic var name: String = ""
    dynamic var author: String = ""
    dynamic var thumbUrl: String = ""
    dynamic var numberOfChap: String = ""
    dynamic var rank: String = ""
    dynamic var dataImage: NSData? = nil
    dynamic var chapterId: String = ""
    dynamic var chapterName: String = "" 
    dynamic var time: String = ""
    dynamic var date = NSDate()
    let genre = List<RecentGenre>()
}
