//
//  FavoriteCity.swift
//  weather2
//
//  Created by  Айя on 13.12.2025.
//

import Foundation
struct FavoriteCity: Codable, Equatable{
    let name: String
    let lat: Double
    let lon: Double
    let country:String?
}
