//
//  WeatherModel.swift
//  runTime
//
//  Created by michael taylor on 10/9/20.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let humidity: Double
    let feelsLike: Double
    let windSpeed: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 800:
            return "sun.min"
        default:
            return "cloud"
        }
    }
    
    var conditionStatement: String {
        switch conditionId {
        case 200...232:
            return "Lightning storms, stay inside for now"
        case 300...321:
            return "Light rain, run at your own risk"
        case 500...531:
            return "Heavy rain, stay inside for now"
        case 600...622:
            return "Snowfall, run at your own risk"
        case 711:
            return "Heavy smoke, stay inside for now"
        case 741:
            return "Fog, run at your own risk"
        case 800:
            return "Clear sky, great running conditions"
        case 801...804:
            return "Cloudy, great running conditions"
        default:
            return "cloud"
        }
    }
    
    
}
