//
//  RestaurantDetailsViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/18.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: Properties
    var restaurantImageUrl: ImageUrls!
    var restaurantName: String!
    var restaurantAddress: String!
    var telephone: String!
    var businessHours: String!
    var holiday: String!
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressMapLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    @IBOutlet weak var restaurantMapView: MKMapView!
    @IBOutlet weak var restaurantHolidaysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = self.restaurantName
        telephoneLabel.text = self.telephone
        if (self.businessHours != "") {
            businessHoursLabel.text = self.businessHours
        }
        if (self.holiday != "") {
            restaurantHolidaysLabel.text = self.holiday
        }
        restaurantAddressMapLabel.text = self.restaurantAddress
        
        
        loadImage()
        locateRestaurant()
    }
    
    // MARK: Actions
    @IBAction func centerOnLocation(_ sender: UITapGestureRecognizer) {
        locateRestaurant()
    }
    
    func locateRestaurant() {
        let location = restaurantAddress
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location!) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.restaurantMapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta = 0.01
                    region.span.latitudeDelta = 0.01
                    self?.restaurantMapView.setRegion(region, animated: true)
                    self?.restaurantMapView.addAnnotation(mark)
                    self?.restaurantMapView.showsUserLocation = true
                }
            }
        }
    }
    
    func loadImage() {
    let urlString = self.restaurantImageUrl.shop_image1
    if (urlString != "") {
        ImageService.loadImage(urlString: urlString!) {
            (result: UIImage) in
            DispatchQueue.main.async {
                self.restaurantImage.image = result
            }
        }
    }


    }
}
