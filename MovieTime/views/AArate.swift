//
//  AArate.swift
//  MovieTime
//
//  Created by כפיר פנירי on 14/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit

class AARate: UIView {
    
    private var stars:[UIImageView] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildStars(frame: self.frame)
    }
    
    override init (frame : CGRect) {
        super.init(frame: frame)
        self.buildStars(frame: frame)
    }
    
    private func buildStars(frame:CGRect){

        //compute size of stars
        let starWidth:Double = Double(frame.size.width)/5.0
        //add stars to view and to stars array
        for i in 0..<5{
            let star = UIImageView.init(image: UIImage.init(named: "empty-star")!)
            star.frame = CGRect.init(x: Double(i)*starWidth, y: 0, width: starWidth, height: Double(frame.size.height))
            self.stars.append(star)
            self.addSubview(star)
        }
    }
    func setRate(rate:Double){
        //parse double to whole and decimal numbers
        let wholeNumbers = Int(rate)
        let decimalNumber = rate - floor(rate)
        //setting stars
        for i in 0..<5{
            if i < wholeNumbers{
                stars[i].image = UIImage.init(named: "full-star")!
            }
            else if i == wholeNumbers{//until now all full stars ended and now required to configure decimal number
                if decimalNumber > 0.5{
                    stars[i].image = UIImage.init(named: "half-star")!
                }
                else{
                   stars[i].image = UIImage.init(named: "empty-star")!
                }
                
            }
            else{
                stars[i].image = UIImage.init(named: "empty-star")!
            }
        }
        
    }

}

