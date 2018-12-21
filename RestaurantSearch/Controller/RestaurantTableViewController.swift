//
//  RestaurantTableViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/19.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    //MARK Properties:
    var latitude: Double = 1.0
    var longitude: Double = 1.0
    let imageCache = NSCache<NSString, UIImage>()

    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        GuruNavi.loadData(latitude: self.latitude, longitude: self.longitude) {
            (result: Restaurants) in
            self.restaurants = result.rest!
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RestaurantTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell else {
            fatalError("The dequeued cell is not an instance of RestaurantTableViewCell.")
        }
        

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.restaurantNameLabel?.text = restaurant.name!
        cell.restaurantAccessLabel?.text = "\(restaurant.access?.line ?? "")\(restaurant.access?.station ?? "")から\(restaurant.access?.walk ?? "")分"
        // Loading cell image thumbnail
        let urlString = restaurant.image_url?.shop_image1
        
        if (urlString != "") {
            // Load image from cache, otherwise load image from url
            if let imageFromCache = imageCache.object(forKey: urlString! as NSString) {
                cell.restaurantImage.image = imageFromCache
            }
            else {
                ImageService.loadImage(urlString: urlString!) {
                    (result: UIImage) in
                    DispatchQueue.main.async {
                        cell.restaurantImage.image = result
                        self.imageCache.setObject(result, forKey: urlString! as NSString)
                    }
                }
            }
        }
        else {
            // reset reused cell thumbnail image to placeholder for restaurants without an image
            cell.restaurantImage.image = UIImage(named: "Restaurant Thumbnail Placeholder")
        }
        return cell
    }
    
    func loadImage(urlString: String) {
        print(urlString)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is RestaurantDetailsViewController
        {
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            let vc = segue.destination as? RestaurantDetailsViewController
            vc?.restaurantImageUrl = restaurants[indexPath.row].image_url
            vc?.restaurantName = restaurants[indexPath.row].name
            vc?.restaurantAddress = restaurants[indexPath.row].address
            vc?.businessHours = restaurants[indexPath.row].opentime
            vc?.telephone = restaurants[indexPath.row].tel
        }
    }

}
