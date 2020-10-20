//
//  SettingsHelper.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/16.
//

import Foundation

class SettingsHelper {
    
    static let  countdownSecondsArray = [30, 25, 20, 15, 10]
    private static let countdownSecondsKey = "countdownSeconds"
    
    
    class func countdownSeconds() -> Int {
        let seconds = UserDefaults.standard.integer(forKey: countdownSecondsKey)
        if countdownSecondsArray.contains(seconds) {
            return seconds
        }
        return countdownSecondsArray[0]
    }
    
    class func saveCountdownSeconds(_ seconds: Int) -> Bool {
        if countdownSecondsArray.contains(seconds) {
            UserDefaults.standard.set(seconds, forKey: countdownSecondsKey)
            return true
        }
        return false
    }
    
}
