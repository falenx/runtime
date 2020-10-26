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
    let chanceOfSnow: Double
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
            case 1183...1189, 1063, 1150, 1153, 1168, 1171, 1180, 1240:
                return "cloud.drizzle"
            case 1192, 1195, 1198, 1201, 1243, 1246:
                return "cloud.heavyrain"
            case 1087, 1273, 1276, 1279, 1282:
                return "cloud.bolt"
            case 1213...1219, 1066, 1069, 1072, 1114, 1204, 1207, 1210, 1249, 1252, 1255, 1261, 1264:
                return "cloud.snow"
            case 1135,1147, 1030:
                return "cloud.fog"
            case 1225,1117, 1222, 1237, 1258:
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
            case 1183...1189,1063,1150, 1153, 1168, 1171, 1180, 1240:
                return "cloud.drizzle"
            case 1192, 1195, 1198, 1201, 1243, 1246:
                return "cloud.moon.rain"
            case 1087, 1273, 1276, 1279, 1282:
                return "cloud.bolt"
            case 1213...1219, 1066, 1069, 1072, 1114, 1204, 1207, 1210, 1249, 1252, 1255, 1261, 1264:
                return "cloud.snow"
            case 1135,1147, 1030:
                return "cloud.fog"
            case 1225,1117, 1222, 1237, 1258:
                return "snow"
            default:
                return "moon"
            }
        }
    }
    
    var conditionStatement: String {
        switch getRunningConditions() {
        case 10:
            return "Perfect conditions for a run"
        case 8,9:
            return "Great conditions for a run"
        case 6,7:
            return "Good conditions for a run"
        case 5:
            return "Tough conditions for a run"
        case 2,3,4:
            return "Bad conditions for a run"
        case 0,1:
            return "Terrible conditions, running not recommended"
        default:
            return "Conditions inconclusive"
        }
    }
    
    
    
    
    func getRunningConditions() -> Int {
        // ideal running temperatures between 55 and 73 degrees
        //humidity under 40% does not have a significant effect
        //humidity over 70% has a drastic effect
        //optimal wind speed is <5 mph 7+is drastic
        //running in anything but light rain in dangerous
        //light rain running is at your own risk, anything more should be avoided
        //var runningConditions = 10
        
        let idealTemp = 60.0
        
        func getTempFactor() -> Double {
            var condition = 10.0
            var tempOffset = 0.0
            
            if temperature > idealTemp {
                tempOffset = temperature - idealTemp
            } else {
                tempOffset = idealTemp - temperature
            }
            
            if (10...14.9).contains(tempOffset) {
                condition -= 3
            } else if (15...25.9).contains(tempOffset) {
                condition -= 6
            } else if (26...100).contains(tempOffset) {
                condition -= 9
            }
            return condition * 0.4
        }
        
        func getHumidityFactor() -> Double {
            var condition = 10.0
            
            if (40...49.9).contains(humidity) {
                condition -= 3
            } else if (50...69.9).contains(humidity) {
                condition -= 6
            } else if (70...100).contains(humidity) {
                condition -= 9
            }
            return condition * 0.3
            
        }
        
        
        func getWindFactor() -> Double {
            var condition = 10.0
            
            if (4...5).contains(windSpeed) {
                condition -= 3
            } else if (5.1...6).contains(windSpeed) {
                condition -= 6
            }
            return condition * 0.1
        }

        
        func getPrecipitationFactor() -> Double {
            var condition = 10.0
            
            if (36...47.8).contains(chanceOfRain) || (36...47.8).contains(chanceOfSnow) {
                condition -= 3
            } else if (48...60).contains(chanceOfRain) || (48...60).contains(chanceOfSnow){
                condition -= 6
            } else if chanceOfRain > 60 || chanceOfSnow > 60 {
                condition -= 9
            }
            return condition * 0.2
        }

        let runningConditions =  Int(round(getTempFactor() + getPrecipitationFactor() + getWindFactor() + getHumidityFactor()))
     
        return runningConditions
    }
    
    
    
    
    
}
