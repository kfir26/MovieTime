//
//  ViewController.swift
//  MovieTime
//
//  Created by כפיר פנירי on 05/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit
import CoreData
import Lottie
import ChameleonFramework

class ViewController: UIViewController{
    
    let animationView = AnimationView()
    
    var swipeRightLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe Right To Movie Time!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 1
        return label
    }()
    
        override func viewDidLoad() {
            super.viewDidLoad()
        read()
            startAnimation()
            
        }


    func startAnimation(){
        MyViewStyle()
           animationView.frame = view.bounds
           animationView.animation = Animation.named("bb8")
        animationView.contentMode = .scaleAspectFill
           animationView.loopMode = .loop
           animationView.play()
             view.addSubview(animationView)
            view.addSubview(swipeRightLabel)
            swipeRightLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
        }
    

        func MyViewStyle(){
               let colors:[UIColor] = [
                 UIColor.flatCoffee(),
                 UIColor.flatBlack()]

            animationView.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom,withFrame: view.frame,andColors: colors)
           }

    

    func callMovie(){
        for movie in  0...14{
            print(get()[movie].title!)
        }
    }
    
    func get()->[MovieCore]{
        let request = NSFetchRequest<MovieCore>(entityName: "MovieCore")
        
        do{
            var movieCore = try CoreDataManager.shared.context.fetch(request)
            
            movieCore.sort(by: {$0.releaseYear > $1.releaseYear})
            
            
            return movieCore
            
            
        }catch{
            print("didnt work mate")
        }
        
        return []
    }


}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor? ,right: NSLayoutXAxisAnchor? ,paddingTop:CGFloat ,paddingLeft: CGFloat, paddingBottom:CGFloat , paddingRight:CGFloat, width:CGFloat , height:CGFloat){
         
         translatesAutoresizingMaskIntoConstraints = false
        
         if let top = top{
             self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
         }

         if let left = left{
                    self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
                }

         if let bottom = bottom{
                    self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
                }

         if let right = right{
                    self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
                }

         if width != 0 {
                    self.widthAnchor.constraint(equalToConstant: width).isActive = true
                }

         if height != 0 {
                    self.heightAnchor.constraint(equalToConstant: height).isActive = true
                }

     }
}



