//
//  Movies.swift
//  MovieTime
//
//  Created by כפיר פנירי on 05/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import Foundation
import UIKit

struct Movies: Codable {
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Int
    let genre: [String]


    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
        case rating = "rating"
        case releaseYear = "releaseYear"
        case genre = "genre"
    }
    
    init(from decoder: Decoder)throws{
        let values =  try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.image = try values.decode(String.self, forKey: .image)
        self.rating = try values.decode(Double.self, forKey: .rating)
        self.releaseYear = try values.decode(Int.self, forKey: .releaseYear)
        self.genre = try values.decode([String].self, forKey: .genre)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(image, forKey: .image)
        try container.encode(rating, forKey: .rating)
        try container.encode(releaseYear, forKey: .releaseYear)
        try container.encode(genre, forKey: .genre)
    }
}


