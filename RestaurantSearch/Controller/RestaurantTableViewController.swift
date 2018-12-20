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
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is RestaurantDetailsViewController
        {
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            let vc = segue.destination as? RestaurantDetailsViewController
            vc?.restaurantName = restaurants[indexPath.row].name
            vc?.restaurantAddress = restaurants[indexPath.row].address
            vc?.businessHours = restaurants[indexPath.row].opentime
            vc?.telephone = restaurants[indexPath.row].tel
            
        }
    }

}
