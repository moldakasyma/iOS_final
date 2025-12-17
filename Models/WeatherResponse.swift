//
//  WeatherResponse.swift
//  weather2
//
//  Created by  Айя on 12.12.2025.
//
import Foundation
struct WeatherResponse: Codable{
    let main: Main
    let weather: [Weather]
}
struct Main: Codable{
    let temp: Double
    let feels_like: Double
}
struct Weather: Codable{
    let main: String
    let description: String
}
