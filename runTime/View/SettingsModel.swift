//
//  SettingsModel.swift
//  runTime
//
//  Created by michael taylor on 10/30/20.
//

import Foundation
import CoreData

struct SettingsModel {
    
    let settingsArray = ["Use Celsius", "Ignore rain", "Ideal humidity", "Ideal wind speed", "Ideal temperature"]
    
    var savedSettingsArray: [NSManagedObject] = []
    
    var isCelsius: Bool?
    var ignoreRain: Bool?
    var idealHumidity: Double?
    var idealWindSpeed: Double?
    var idealTemperature: Double?
    
    
    
}
