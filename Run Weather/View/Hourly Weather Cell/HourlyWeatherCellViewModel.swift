//
//  HourlyWeatherCellViewModel.swift
//  runTime
//
//  Created by Kyle Kirkland on 11/21/20.
//

import Foundation
import UIKit

/// Presentation logic 
extension HourlyWeatherCell.Model {
    
    static func mockTestData() -> HourlyWeatherCell.Model {
        return HourlyWeatherCell.Model(chanceOfRain: "test", feelsLike: "test", runningCondition: "test", runningConditionsColor: .blue, windSpeed: "test", weatherIconName: "test", currentHour: "test")
    }
}

extension HourlyWeatherCell.Model {
    
    init(weather: WeatherModel, currentHour: Int, offSet: Int, settings: SettingsModel) {
        let futureHour = currentHour + offSet
        let hour = weather.hoursArray[futureHour]
        chanceOfRain = String(hour.chanceOfRain)
        if (settings.isCelsius ?? false) {
            feelsLike = String(hour.feelsLikeC)
        } else {
            feelsLike = String(hour.feelsLikeF)
        }
        
        runningCondition = String(hour.getRunningConditions())
        runningConditionsColor = Formatters.getRunningConditionsColor(hour.getRunningConditions())
        windSpeed = "\(hour.windSpeed) MPH"
        weatherIconName = hour.conditionName
        self.currentHour = Formatters.hourString(from: hour.currentHour)
    }
    
}
