//
//  RestaurantDetailsViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/18.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit

import UIKit

class RestaurantDetailsViewController: UIViewController {
    //MARK: Properties
    var restaurantImageUrl: String!
    var restaurantName: String!
    var restaurantAddress: String!
    var telephone: String!
    var businessHours: String!
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = self.restaurantName
        restaurantAddressLabel.text = self.restaurantAddress
        telephoneLabel.text = self.telephone
        businessHoursLabel.text = self.businessHours
    }
}