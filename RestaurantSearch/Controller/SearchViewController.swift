//
//  SearchViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/18.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Properties
    let locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    @IBOutlet weak var label: UILabel!
    
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
    
    func setLabel(text: String) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            self.label.text = text
        }
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is RestaurantTableViewController
        {
            let vc = segue.destination as? RestaurantTableViewController
            vc?.latitude = self.latitude
            vc?.longitude = self.longitude
            //self.present(vc!, animated: true, completion: nil)
        }
    }
}

