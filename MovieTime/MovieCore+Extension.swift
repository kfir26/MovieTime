//
//  MovieCore+Extension.swift
//  MovieTime
//
//  Created by כפיר פנירי on 06/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import Foundation

extension MovieCore{

    convenience init(title:String,image:String, rating:Double, releaseYear: Int, genre:[String]){
        
        self.init(context: CoreDataManager.shared.context)
        self.title = title
        self.image = image
        self.rating = rating
        self.releaseYear = Int16(releaseYear)
        self.genre = genre
    }
    
    convenience init(json: [String: Any]){
        self.init(context: CoreDataManager.shared.context)
        self.title = json["title"] as? String
        self.image = json["image"] as? String
        self.rating = json["rating"] as? Double ?? 0
        self.releaseYear = json["releaseYear"] as? Int16 ?? 0
        self.genre = json["genre"] as? [String] ?? []
    }
}


