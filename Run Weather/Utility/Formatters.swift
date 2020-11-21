//
//  Formatters.swift
//  runTime
//
//  Created by Kyle Kirkland on 11/21/20.
//

import Foundation
import UIKit

/// Reusable code that is used to transofrm values into other types
/// Good for formatting degress, or wind speed, running condition, etc.
struct Formatters {

    static func hourString(from militaryHour: Int) -> String {
        if militaryHour > 11 {
            return "\(dateConvert(date: militaryHour)) PM"
        } else if militaryHour == 0 {
            return "12 AM"
        }else {
            return "\(militaryHour) AM"
        }
    }
    
    static func degressString(from temperature: String) -> String {
        return "\(temperature) °"
    }
    
    static func getRunningConditionsColor(_ runCondition: Int) -> UIColor {
        if runCondition == 10 {
            return UIColor(red: 54/256, green: 181/256, blue: 0/256, alpha: 1.0)
        } else if (7...9).contains(runCondition) {
            return UIColor(red: 118/256, green: 255/256, blue: 0/256, alpha: 1.0)
        } else if (4...6).contains(runCondition) {
            return UIColor(red: 255/256, green: 204/256, blue: 0/256, alpha: 1.0)
        } else {
            return UIColor.red
        }
    }
    
    static func dateConvert(date: Int) -> Int {
        if date == 12 {
            return 12
        }
        return date - 12
    }

}


