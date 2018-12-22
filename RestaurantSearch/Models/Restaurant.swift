//
//  Restaurant.swift
//  RestaurantSearch
//
//  Created by Darren Tang on 2018/12/18.
//  Copyright © 2018 Darren Tang. All rights reserved.
//

import Foundation

struct Restaurants: Decodable {
    let total_hit_count: Int?
    let hit_per_page: Int?
    let rest: [Restaurant]?
    let error: [Error]?
}

struct Restaurant: Decodable {
    let id: String?
    let name: String?
    let category: String?
    let image_url: ImageUrls?
    let address: String?
    let tel: String?
    let tel_sub: String?
    let opentime: String?
    let holiday: String?
    let access: Access?
    let credit_card: String?
}

struct Access: Decodable {
    let line: String?
    let station: String?
    let walk: String?
}

struct ImageUrls: Decodable {
    let shop_image1: String?
    let shop_image2: String?
}

struct Error: Decodable {
    let code: Int?
    let message: String?
}
