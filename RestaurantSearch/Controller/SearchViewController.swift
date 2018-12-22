//
//  SearchViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/18.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, SearchFilterModalViewControllerDelegate {

    //MARK: Properties
    let locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    var filterCreditCard: Bool = false
    var searchRadius: Int = 2
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up CoreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func searchRestaurants(_ sender: UIButton) {
        print(self.latitude)
        print(self.longitude)
        locationManager.startUpdatingLocation()
    }
    
    //MARK: LocationManager Delegate Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
    }
    
    //MARK: Search Filter Modal Delegate Functions
    
    // receive filter settings from modal
    func receiveSettings(searchRadius: Int, creditCard: Bool) {
        self.searchRadius = searchRadius
        self.filterCreditCard = creditCard
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is RestaurantTableViewController {
            let vc = segue.destination as? RestaurantTableViewController
            vc?.latitude = self.latitude
            vc?.longitude = self.longitude
        }
        else if segue.destination is SearchFilterModalViewController {
            let vc = segue.destination as? SearchFilterModalViewController
            vc?.creditCardToggle = self.filterCreditCard
            vc?.searchRadius = self.searchRadius
            vc?.delegate = self
        }
    }
}

