//
//  SearchFilterModalViewController.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/22.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit

class SearchFilterModalViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var searchRadiusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    
    weak var delegate: SearchFilterModalViewControllerDelegate?
    var searchRadius: Int!
    var creditCardToggle: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchRadiusSegmentedControl.selectedSegmentIndex = self.searchRadius
        self.creditCardSwitch.isOn = self.creditCardToggle
    }
    
    @IBAction func closeModal(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyFilterSettings(_ sender: UIButton) {
        let searchRadiusOption = searchRadiusSegmentedControl.selectedSegmentIndex
        let creditCardOption = creditCardSwitch.isOn
        delegate?.receiveSettings(searchRadius: searchRadiusOption, creditCard: creditCardOption)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol SearchFilterModalViewControllerDelegate: class {
    func receiveSettings(searchRadius: Int, creditCard: Bool)
}
