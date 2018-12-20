//
//  NetworkService.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/19.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import Foundation

class GuruNavi {
    
    static func loadData(latitude: Double, longitude: Double, completion: @escaping (_ result: Restaurants) -> Void) {
        let urlString = "https://api.gnavi.co.jp/RestSearchAPI/v3/?"
        let key = "keyid=ab00927be99b10950134df66ea9b85e9"
        let range = "range=5"
        
        let jsonUrlString = "\(urlString)\(key)&\(range)&latitude=\(latitude)&longitude=\(longitude)"
        
        print(jsonUrlString)
        
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
