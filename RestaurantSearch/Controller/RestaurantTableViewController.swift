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
    var latitude: Double!
    var longitude: Double!
    var creditCard: Bool!
    var searchRadius: Int!
    var searchTerms: String!
    var pagesLoaded: Int!
    var maxPages: Int!
    let imageCache = NSCache<NSString, UIImage>()

    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.pagesLoaded = 0
        loadRestaurantData()
    }

    func loadRestaurantData() {
        GuruNavi.loadData(latitude: self.latitude, longitude: self.longitude, searchRadius: self.searchRadius, creditCard: self.creditCard, searchTerms: self.searchTerms, page: (self.pagesLoaded + 1)) {
            (result: Restaurants) in
            if (result.error == nil) {
                self.restaurants.append(contentsOf: result.rest!)
                self.pagesLoaded == 0 ? (self.pagesLoaded = 1) : (self.pagesLoaded = (self.pagesLoaded + 1))
                self.maxPages = (result.total_hit_count! / result.hit_per_page!) + 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else if (self.pagesLoaded == 0){
                DispatchQueue.main.async {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                    noDataLabel.text          = result.error?[0].message
                    noDataLabel.textColor     = UIColor.black
                    noDataLabel.textAlignment = .center
                    self.tableView.backgroundView  = noDataLabel
                    self.tableView.separatorStyle  = .none
                }
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
        
        //Load additional pages when reaching end of list
        if (indexPath.row == self.restaurants.count - 1 && self.pagesLoaded < self.maxPages) {
           loadRestaurantData()
        }

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.restaurantNameLabel?.text = restaurant.name!
        var restaurantAccessWalk: String = ""
        if (restaurant.access?.walk != "") {
            restaurantAccessWalk = "から\(restaurant.access?.walk ?? "")分"
        }
        let restaurantAccess = "\(restaurant.access?.line ?? "")\(restaurant.access?.station ?? "")\(restaurantAccessWalk)"
        cell.restaurantAccessLabel?.text = restaurantAccess
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

    //MARK: Navigation
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
            vc?.holiday = restaurants[indexPath.row].holiday
            vc?.telephone = restaurants[indexPath.row].tel
        }
    }

}
