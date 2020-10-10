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
    let windDirection: String
    let uvRating: Double
    let chanceOfRain: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 1000:
            return "sun.max"
        case 1003:
            return "cloud.sun"
        case 1006...1009:
            return "cloud"
        case 1183...1189:
            return "cloud.drizzle"
        case 1195, 1243, 1246:
            return "cloud.heavyrain"
        case 1213...1219:
            return "cloud.snow"
        case 1225:
            return "snow"
        default:
            return "sun.min"
        }
    }
    
    var conditionStatement: String {
        switch conditionId {
        case 1000:
            return "Clear skies, great running conditions"
        case 1003:
            return "Some clouds, great running conditions"
        case 1006...1009:
            return "Cloudy, perfect running conditions"
        case 1183...1189:
            return "Light rain, run at your own risk"
        case 1195, 1243, 1246:
            return "Heavy rain, bad time for a run"
        case 1213...1219:
            return "Light snow, run at your own risk"
        case 1225:
            return "Heavy snow, bad time for a run"
        default:
            return "sun.min"
        }
    }
    
    
}
