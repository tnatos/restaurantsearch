//
//  RestaurantTableViewCell.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/19.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    //MARK: Properties
    var imageUrl: String!
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAccessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        self.contentView.layer.cornerRadius = 5 
    }
    

}
