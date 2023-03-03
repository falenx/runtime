//
//  WeatherData.swift
//  runTime
//
//  Created by michael taylor on 10/9/20.
//

import Foundation

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
    let temp_c: Double
    let wind_mph: Double
    let humidity: Double
    let feelslike_f: Double
    let feelslike_c: Double
    let uv: Double
    let condition: APICondition
    let is_day: Int
}

struct APIForecast : Decodable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Decodable {
    let hour: [APIHour]
}

struct APIHour: Decodable {
    let chance_of_rain: Double
    let chance_of_snow: Double
    let condition: APICondition
    let wind_mph: Double
    let temp_f: Double
    let temp_c: Double
    let humidity: Double
    let feelslike_f: Double
    let feelslike_c: Double
    let is_day: Int
}

struct APICondition: Decodable {
    let code: Int
}

