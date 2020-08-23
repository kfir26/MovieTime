//
//  MovieViewController.swift
//  MovieTime
//
//  Created by כפיר פנירי on 06/08/2020.
//  Copyright © 2020 Kfir. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import ChameleonFramework

class MovieViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var movies:[MovieCore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = get()
    }
    
    //MARK: - TableView Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         UITableView.automaticDimension
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showMovieDetails", sender: movies[indexPath.row])
    }
    
    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MTableViewCell
        cell.populate(with: movie)

        cell.poster.sd_setImage(with: URL.init(string:movie.image!), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions(), progress: nil, completed: nil)
        
        cell.StarRate.setRate(rate: Double(movie.rating/2))
        
        let colors:[UIColor] = [
        UIColor.flatCoffee(),
        UIColor.flatSkyBlueColorDark()
        ]
        cell.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight,withFrame: view.frame, andColors:colors)
        
//        print(movie)
        
        return cell

    }
    //MARK: - Segue Method
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the segue is to details:
            if segue.identifier == "showMovieDetails" {
                let destVc = segue.destination as! MovieDetailsViewController
                destVc.movie = sender as? MovieCore
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
