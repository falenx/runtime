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
    let uvRating: Double
    let chanceOfRain: Double
    let currentHour: Int
    let isDay: Int
    var temperatureString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    var hoursArray: [WeatherModel]
    
    var conditionName: String {
        if (isDay == 1) {
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

        } else {
            switch conditionId {
            case 1000:
                return "moon.stars"
            case 1003:
                return "cloud.moon"
            case 1006...1009:
                return "cloud"
            case 1183...1189:
                return "cloud.drizzle"
            case 1195, 1243, 1246:
                return "cloud.moon.rain"
            case 1213...1219:
                return "cloud.snow"
            case 1225:
                return "snow"
            default:
                return "moon"
            }
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
    
    
    
    
    func getRunningConditions() -> [String] {
        // ideal running temperatures between 55 and 73 degrees
        //humidity under 40% does not have a significant effect
        //humidity over 70% has a drastic effect
        //optimal wind speed is <5 mph 7+is drastic
        //running in anything but light rain in dangerous
        //light rain running is at your own risk, anything more should be avoided
        var runningConditions = 10
        var cantRunReason: String?
        var runningConditionsArray: [String] = []
        
        //absolutely unrunnable conditions
        if temperature < 32 || temperature > 90 {
            runningConditions = 0
            cantRunReason = "temperature is unbearable"
            runningConditionsArray.append(String(runningConditions))
            runningConditionsArray.append(cantRunReason ?? "")
            return runningConditionsArray
        } else if (1195...1246).contains(conditionId) {
            runningConditions = 0
            cantRunReason = "Weather is unbearable"
            runningConditionsArray.append(String(runningConditions))
            runningConditionsArray.append(cantRunReason ?? "")
            return runningConditionsArray
        } else if windSpeed > 15 {
            runningConditions = 0
            cantRunReason = "Wind is unbearable"
            runningConditionsArray.append(String(runningConditions))
            runningConditionsArray.append(cantRunReason ?? "")
            return runningConditionsArray
        } else {
            
        }
        
        //temperature effect on running conditions
        
        if (33...40.9).contains(temperature) {
            runningConditions -= 2
        } else if (41...47).contains(temperature) {
            runningConditions -= 1
        } else if (78...84.2).contains(temperature) {
            runningConditions -= 1
        } else if (84.3...90).contains(temperature) {
            runningConditions -= 2
        } else {

        }
        
        //print("temperature is \(temperature) lowered running conditions to \(runningConditions)")
        
        //humidity effect on running conditions
        
        if (25...39.9).contains(humidity) {
            runningConditions = runningConditions - 1
        } else if (40...59.9).contains(humidity) {
            runningConditions = runningConditions - 2
        } else if (60...69).contains(humidity) {
            runningConditions = runningConditions - 3
        } else if humidity > 69 {
            runningConditions = runningConditions - 4
        } else {
            
        }
        
        //print("humidity \(humidity) lowered running conditions to \(runningConditions)")

        //wind speed effect on running conditions
        
        if (5...6).contains(windSpeed) {
            runningConditions = runningConditions - 1
        } else if windSpeed > 6 {
            runningConditions = runningConditions - 2
        } else {
            
        }
        
        //print("wind \(windSpeed) lowered running conditions to \(runningConditions)")


        //rain chance effect on running conditions
        if (36...47.8).contains(chanceOfRain) {
            runningConditions = runningConditions - 1
        } else if (48...60).contains(chanceOfRain) {
            runningConditions = runningConditions - 2
        } else if chanceOfRain > 60 {
            runningConditions = runningConditions - 3
        }
        
        //print("rain is \(chanceOfRain) lowered running conditions to \(runningConditions)")

        
        if runningConditions < 0 {
            runningConditions = 0
        }
        
        runningConditionsArray.append(String(runningConditions))
        runningConditionsArray.append(cantRunReason ?? "")
        //print("running conditions are \(runningConditions)")
        return runningConditionsArray
    }
    
    
    
}
