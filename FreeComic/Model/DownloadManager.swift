//
//  DownloadManager.swift
//  FreeComic
//
//  Created by Enrik on 1/9/17.
//  Copyright © 2017 Enrik. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import Reachability
import SwiftyJSON
import RealmSwift

class DownloadManager {
    static let share = DownloadManager()
    
    func downloadAllOrTop(stringURL: String, completion: @escaping(_ stories:[Story]) -> Void) {
        guard let url = URL(string: stringURL) else {
            return
        }
            var stories = [Story]()
            
            Alamofire.request(url).responseJSON { (response) in
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let mangas = json["mangas"].arrayValue
                    
                    for manga in mangas {
                        guard let id = manga["i"].string else {
                            continue
                        }
                        guard let name = manga["n"].string else {
                            continue
                        }
                        guard let thumbUrl = manga["c"].string else {
                            continue
                        }
                        guard let numberOfChap = manga["t"].string else {
                            continue
                        }
                        guard let rank = manga["r"].string else {
                            continue
                        }
                        var genre = [String]()
                        if let genresJson = manga["g"].array {
                            for genreJson in genresJson {
                                if let item = genreJson["i"].string {
                                    genre.append(item)
                                }
                            }
                        }
                        var author = ""
                        if let authorsJson = manga["a"].array {
                            if let au = authorsJson[0]["n"].string {
                                author = au
                            }
                        }
                        let story = Story(id: id, name: name, genre: genre, author: author, thumbUrl: thumbUrl, numberOfChap: numberOfChap, rank: rank)
                        stories.append(story)
                    }
                    completion(stories)
                }
            }
    }
    
    func downloadNew(stringURL: String, completion: @escaping(_ stories:[Story]) -> Void) {
        guard let url = URL(string: stringURL) else {
            return
        }
        print("url", url)
        var stories = [Story]()
        
        Alamofire.request(url).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                
                let update = json["update"]
                
                let mangas = update["mangas"].arrayValue
                
                for manga in mangas {
                    guard let id = manga["i"].string else {
                        continue
                    }
                    guard let name = manga["n"].string else {
                        continue
                    }
                    guard let thumbUrl = manga["c"].string else {
                        continue
                    }
                    guard let numberOfChap = manga["t"].string else {
                        continue
                    }
                    guard let rank = manga["r"].string else {
                        continue
                    }
                    var genre = [String]()
                    if let genresJson = manga["g"].array {
                        for genreJson in genresJson {
                            if let item = genreJson["i"].string {
                                genre.append(item)
                            }
                        }
                    }
                    var author = ""
                    if let authorsJson = manga["a"].array {
                        if let au = authorsJson[0]["n"].string {
                            author = au
                        }
                    }
                    let story = Story(id: id, name: name, genre: genre, author: author, thumbUrl: thumbUrl, numberOfChap: numberOfChap, rank: rank)
                    stories.append(story)
                }
                completion(stories)
            }
        }
        
    }
    
    func downloadDetailStory(stringURL: String, completion: @escaping(_ detailStory: DetailStory?) -> Void) {
        guard let url = URL(string: stringURL) else {
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
            
                let mangaDetail = json["manga-detail"]
            
                guard let name = mangaDetail["name"].string else {
                    return
                }
                
                var author = ""
                if let authorsJson = mangaDetail["author"].array {
                    if let au = authorsJson[0]["name"].string {
                        author = au
                    }
                }
            
                guard let id = mangaDetail["id"].string else { return }
                
                guard let summary = mangaDetail["summary"].string else { return }
                
                guard let thumbUrl = mangaDetail["cover"].string else { return }
                
                guard let rank = mangaDetail["rank"].string else { return }
                
                guard let numberChapter = mangaDetail["num_chapter"].string else { return }
                
                var genres = [Genre]()
                
                guard let genre = mangaDetail["genre"].array else { return }
                
                for item in genre {
                    guard let nameGenre = item["name"].string else { continue }
                    
                    guard let idGenre = item["id"].string else { continue }
                    
                    genres.append(Genre(name: nameGenre, id: idGenre))
                }
                
                var chapters = [Chapter]()
                
                guard let chapter = mangaDetail["chapters"].array else { return }
                
                for item in chapter {
                    guard let nameChapter = item["name"].string else { return }
                    
                    guard let idChapter = item["i"].string else { return }
                    
                    chapters.append(Chapter(name: nameChapter, id: idChapter))
                }
                
                let detailStory = DetailStory(name: name, thumbUrl: thumbUrl, id: id, rank: rank, author: author, numberChapter: numberChapter, summary: summary, genres: genres, chapters: chapters)
                completion (detailStory)
            }
        
            completion(nil)
        }
        
    }
    
    func downloadDetailChapter(stringURL: String, completion: @escaping(_ listImage: [Image]?) -> Void) {
        guard let url = URL(string: stringURL) else {
            return
        }
        
        var listImage = [Image]()
        
        Alamofire.request(url).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                
                let chapter = json["chapter"]
                
                guard let page = chapter["page"].array else { return }
                
                for item in page {
                    guard let number = item["n"].int else { continue }
                    guard let link = item["u"].string else { continue }
                    listImage.append(Image(page: number, link: link))
                }
             
                completion(listImage)
            }
            completion(nil)
        }

    }
    
    func downloadOfflineChapter(stringURL: String, completion: @escaping(_ listDataImage: [ImageData]?) -> Void) {

        guard let url = URL(string: stringURL) else {
            return
        }
        
        var listImage = [ImageData]()
        
        Alamofire.request(url).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                
                let chapter = json["chapter"]
                
                guard let page = chapter["page"].array else { return }

                var count = 0
                
                for item in page {
                   
                    guard let link = item["u"].string else { continue }
                    guard let number = item["n"].int else { continue }
                    
                    let linkUrl = URL(string: link)
                    print(linkUrl!)
                    
                    ImageDownloader.default.downloadImage(with: linkUrl!, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
                        
                        if image != nil {
                            
                            let imageData = ImageData()
                            
                            imageData.dataImage = image!.pngData()! as NSData?
                            imageData.number = number 
                            listImage.append(imageData)
                        }
                        
                        count += 1
                        if count == page.count {
                            completion(listImage)
                        }
 
                    })

                }

            }
            completion(nil)
        }
        
    }
    
    func downloadOfflineStory(story: Story, chapter: Chapter, detailStory: DetailStory) {
        
        let realm = try! Realm()
        
        let objects = realm.objects(OfflineStory.self)
        
        var check = false
        for object in objects {
            if object.id == story.id {
                check = true
                let link = String(format: Constant.Request.requestChapter, chapter.id)
                
                DownloadManager.share.downloadOfflineChapter(stringURL: link, completion: { (listImageData) in
                    if listImageData != nil {
                        let offlineChapter = OfflineChapter()
                        offlineChapter.chapterId = chapter.id
                        offlineChapter.chapterName = chapter.name
                        
                        let sortedList = listImageData?.sorted(by: { (a, b) -> Bool in
                            a.number < b.number
                        })
                        
                        for imageData in sortedList! {
                            offlineChapter.images.append(imageData)
                        }
                        try! realm.write {
                            object.chapters.append(offlineChapter)
                        }
                        
                    }
                })
                
                break
            }
        }
        
        if check == false {
            let offlineStory = OfflineStory()
            
            offlineStory.id = story.id
            offlineStory.name = story.name
            offlineStory.author = story.author
            offlineStory.thumbUrl = story.thumbUrl
            offlineStory.numberOfChap = story.numberOfChap
            offlineStory.rank = story.rank
            offlineStory.summary = detailStory.summary
            
            if let data = story.image!.pngData() {
                offlineStory.dataThumb = data as NSData
            }
            
            for item in story.genre {
                let offlineGenre = RealmGenre()
                offlineGenre.id = item
                offlineStory.genres.append(offlineGenre)
            }
            
            try! realm.write {
                realm.add(offlineStory)
            }
            
            let link = String(format: Constant.Request.requestChapter, chapter.id)
            
            DownloadManager.share.downloadOfflineChapter(stringURL: link, completion: { (listImageData) in
                if listImageData != nil {
                    let offlineChapter = OfflineChapter()
                    offlineChapter.chapterId = chapter.id
                    offlineChapter.chapterName = chapter.name
                    
                    let sortedList = listImageData?.sorted(by: { (a, b) -> Bool in
                        a.number < b.number
                    })
                    
                    for imageData in sortedList! {
                        offlineChapter.images.append(imageData)
                    }
                    
                    do {
                        try realm.write {
                            offlineStory.chapters.append(offlineChapter)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
        }

    }
    
}
