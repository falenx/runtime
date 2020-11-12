//
//  WeatherModelStore.swift
//  runTime
//
//  Created by michael taylor on 10/19/20.
//

import Foundation



class WeatherModelStore {
    
    static let shared = WeatherModelStore()
    
    var model: WeatherModel?
    
    func updateModel(_ weatherModel: WeatherModel){
        self.model = weatherModel
    }
    
}
