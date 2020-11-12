//
//  SettingsModelStore.swift
//  runTime
//
//  Created by michael taylor on 11/2/20.
//

import Foundation

class SettingsModelStore {
    
    static let shared = SettingsModelStore()
    
    var model: SettingsModel?
    
    func updateModel(_ settingsModel: SettingsModel){
        self.model = settingsModel
    }
    
}
