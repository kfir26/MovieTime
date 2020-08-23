//
//  MovieDetailsViewController.swift
//  MovieTime
//
//  Created by כפיר פנירי on 12/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit
import SDWebImage
import Lottie

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var rate: AARate!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var animationX: UIView!
    
    @IBOutlet weak var TVLogo: AnimationView!
    
    var movie:MovieCore?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAll()
        startAnimation()

    }
    
    func setAll(){
        guard let posters = movie?.image else {return}
        print(posters)
        guard let url = URL(string: posters)else{return}
        
        poster.sd_setImage(with: url, placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions(),context: nil, progress: nil)
        
        labelTitle.text = movie?.title
        rate.setRate(rate: Double(movie!.rating/2))
        genre.text = String(movie?.genre?[0] ?? "")
        releaseYear.text = String(movie!.releaseYear)

    }
    
    func startAnimation(){
           TVLogo.frame = view.bounds
           TVLogo.animation = Animation.named("Agents of H.A.T.E")
        TVLogo.contentMode = .scaleToFill
           TVLogo.loopMode = .loop
           TVLogo.play()
        view.addSubview(TVLogo)
        
        }
    
}



