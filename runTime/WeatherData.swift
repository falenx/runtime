//
//  WeatherData.swift
//  runTime
//
//  Created by michael taylor on 10/9/20.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}


struct Main: Decodable {
    let temp: Double
    let humidity: Double
    let feelsLike: Double
}

struct Weather: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
}
