//
//  Settings.swift
//  GPS
//
//  Created by Maxim Mazhuga on 16.05.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

private let sleepTimer = 3.0
let categoryOfSettings = ["Данные"]
let markersSettingsMenu = ["Автообновление"]
let markersAutoLoadingSettingsMenu = [("Раз в 5 секунд", 5.0), ("Раз в 10 секунд", 10.0), ("Раз в 15 секунд", 15.0), ("Раз в 30 секунд", 30.0), ("Выключено", 0.0)]

extension SettingsRepositoryImpl {
    
    func getTimeForTimer() -> Double {
        if UserDefaults.standard.object(forKey: "TimeForMarkersAutoLoading") != nil {
            return Double((UserDefaults.standard.object(forKey: "TimeForMarkersAutoLoading") as! [String]).last!)!
        } else {
            //default time for timer
            return 10.0
        }
    }
    
        func getNameForTimer() -> String {
            if UserDefaults.standard.object(forKey: "TimeForMarkersAutoLoading") != nil {
                return (UserDefaults.standard.object(forKey: "TimeForMarkersAutoLoading") as! [String]).first!
            } else {
                //default time for timer
                return "Раз в 10 секунд"
            }
    }

    func getSleepTime() -> Double {
        return sleepTimer
    }

}
