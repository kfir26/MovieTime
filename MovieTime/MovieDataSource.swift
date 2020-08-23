//
//  MovieDataSource.swift
//  MovieTime
//
//  Created by כפיר פנירי on 05/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import Foundation

func read(){
    guard let url = Bundle.main.url(forResource: "movie",
                                    withExtension: "json") else {return}

    guard let data = try? Data(contentsOf: url) else {return}

    let decoder = JSONDecoder()

    guard let movies = try? decoder.decode([Movies].self, from: data) else {return}
    for movie in movies{
        _ = MovieCore(title: movie.title, image: movie.image, rating: movie.rating, releaseYear: movie.releaseYear, genre: movie.genre)
        

        CoreDataManager.shared.saveContext()

    }
}

