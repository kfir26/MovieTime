//
//  MTableViewCell.swift
//  MovieTime
//
//  Created by כפיר פנירי on 12/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit

class MTableViewCell: UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var releaseYear: UILabel!
    
    @IBOutlet weak var genre: UILabel!
    
    @IBOutlet weak var StarRate: AARate!
    
    

    func populate(with movies: MovieCore){
        mainTitle.text = movies.title
//        releaseYear.text = String(movies.releaseYear)
//        genre.text = String(movies.genre?[0] ?? "")

    }

}
