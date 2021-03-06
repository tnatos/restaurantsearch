//
//  NetworkService.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/19.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import UIKit

class GuruNavi {
    
    static func loadData(latitude: Double, longitude: Double, searchRadius: Int, creditCard: Bool, searchTerms: String, page: Int, completion: @escaping (_ result: Restaurants) -> Void) {
        let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?"
        let key = "keyid=ab00927be99b10950134df66ea9b85e9"
        let range = "&range=\(searchRadius)"
        let card = "&card=\(creditCard ? 1 : 0)"
        let processedSearchTerm = searchTerms.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let freeword = "&freeword=\(processedSearchTerm)"
        let offsetPage = "&offset_page=\(page)"
        
        let jsonUrlString = "\(urlString)\(key)&\(range)&latitude=\(latitude)&longitude=\(longitude)\(card)\(freeword)\(offsetPage)"

        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let restaurants = try JSONDecoder().decode(Restaurants.self, from: data)
                completion(restaurants)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
}

class ImageService {
    
    static func loadImage(urlString: String, completion: @escaping (_ result: UIImage) -> Void) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            completion(image!)
            }.resume()
    }
}
