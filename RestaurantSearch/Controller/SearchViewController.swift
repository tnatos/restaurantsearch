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
    var searchTerms: String!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up CoreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        searchTextField.delegate = self
        self.searchTerms = ""
    }

    // MARK: Actions
    @IBAction func searchRestaurants(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func searchTextFieldChanged(_ sender: UITextField) {
        self.searchTerms = sender.text
    }
    
    // MARK: LocationManager Delegate Functions
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
    
    // MARK: Search Filter Modal Delegate Functions
    
    // receive filter settings from modal
    func receiveSettings(searchRadius: Int, creditCard: Bool) {
        self.searchRadius = searchRadius
        self.filterCreditCard = creditCard
    }
    
    // MARK: Search Textfield Delegate Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if checkLocationServicesEnabled() {
        self.performSegue(withIdentifier: "searchRestaurantSegue", sender: self)
        }
        else {
            showLocationServicesDisabledAlert()
        }
        return true
    }
    
    // MARK: Alerts
    func showLocationServicesDisabledAlert() {
        let alert = UIAlertController(title: "位置情報", message: "位置情報サービスはアプリ許可されていない場合検索できません。位置情報サービスをオンにしてください。", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkLocationServicesEnabled() -> Bool {

        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                showLocationServicesDisabledAlert()
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            showLocationServicesDisabledAlert()
            return false
        }
    }
    
    
    
    // MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "searchRestaurantSegue") {
            return checkLocationServicesEnabled()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        searchTextField.resignFirstResponder()
        if segue.destination is RestaurantTableViewController {
            let vc = segue.destination as? RestaurantTableViewController
            vc?.latitude = self.latitude
            vc?.longitude = self.longitude
            vc?.searchRadius = self.searchRadius + 1
            vc?.creditCard = self.filterCreditCard
            vc?.searchTerms = self.searchTerms
        }
        else if segue.destination is SearchFilterModalViewController {
            let vc = segue.destination as? SearchFilterModalViewController
            vc?.creditCardToggle = self.filterCreditCard
            vc?.searchRadius = self.searchRadius
            vc?.delegate = self
        }
    }
}

