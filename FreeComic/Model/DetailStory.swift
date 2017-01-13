//
//  DetailStory.swift
//  FreeComic
//
//  Created by Enrik on 1/12/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation

class DetailStory {
    var name: String
    var thumbUrl: String
    var id: String
    var rank: String
    var author: String
    var numberChapter: String
    var summary: String
    var genres: [Genre]
    var chapters: [Chapter]
    
    
    init(name: String, thumbUrl: String, id: String, rank: String, author: String, numberChapter: String, summary: String, genres: [Genre], chapters: [Chapter]) {
        self.name = name
        self.thumbUrl = thumbUrl
        self.id = id
        self.rank = rank
        self.author = author
        self.numberChapter = numberChapter
        self.summary = summary
        self.genres = genres
        self.chapters = chapters
    }
}
