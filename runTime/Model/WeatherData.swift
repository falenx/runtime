//
//  WeatherData.swift
//  runTime
//
//  Created by michael taylor on 10/9/20.
//

import Foundation
/*
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}


struct Main: Decodable {
    let temp: Double
    let humidity: Double
    let feels_like: Double
}

struct Weather: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
}

*/


//MARK: - New Stuff


struct APIWeatherData: Decodable {
    let location: APILocation
    let current: APICurrent
    let forecast: APIForecast
}


struct APILocation: Decodable {
    let name: String
    let localtime: String
}

struct APICurrent: Decodable {
    let temp_f: Double
    let wind_mph: Double
    //let wind_dir: String
    let humidity: Double
    let feelslike_f: Double
    let uv: Double
    let condition: APICondition
}

struct APIForecast : Decodable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Decodable {
    let hour: [APIHour]
}

struct APIHour: Decodable {
    let chance_of_rain: String
    let condition: APICondition
    let wind_mph: Double
    let temp_f: Double
    let humidity: Double
    let feelslike_f: Double
}

struct APICondition: Decodable {
    let code: Int
}

