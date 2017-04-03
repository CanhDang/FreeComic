//
//  OfflineStory.swift
//  FreeComic
//
//  Created by Enrik on 2/7/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation
import RealmSwift

class ImageData: Object {
    dynamic var number: Int = 0
    dynamic var dataImage: NSData? = nil
}

class OfflineChapter: Object {
    dynamic var chapterId: String = ""
    dynamic var chapterName: String = ""
    let images = List<ImageData>()
}

class OfflineStory: Object {
    dynamic var id = ""
    dynamic var name: String = ""
    dynamic var author: String = ""
    dynamic var thumbUrl: String = ""
    dynamic var numberOfChap: String = ""
    dynamic var rank: String = ""
    dynamic var dataThumb: NSData? = nil
    dynamic var summary: String = ""
    
    let genres = List<RealmGenre>()
    let chapters = List<OfflineChapter>()
}
