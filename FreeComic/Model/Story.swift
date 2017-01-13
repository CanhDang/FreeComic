//
//  Story.swift
//  FreeComic
//
//  Created by Enrik on 1/9/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation

class Story {
    var id: String
    var name: String
    var genre: [String]
    var author: String
    var thumbUrl: String
    var numberOfChap: String
    var rank: String
    var image: UIImage!
    
    init(id: String, name: String, genre: [String], author: String, thumbUrl: String, numberOfChap: String, rank: String) {
        self.id = id
        self.name = name
        self.genre = genre
        self.author = author
        self.thumbUrl = thumbUrl
        self.numberOfChap = numberOfChap
        self.rank = rank
    }
}
