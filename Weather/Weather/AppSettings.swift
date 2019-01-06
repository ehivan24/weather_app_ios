//
//  AppSettings.swift
//  Weather
//
//  Created by edwing santos on 1/5/19.
//  Copyright © 2019 edwing santos. All rights reserved.
//

import Foundation

class AppSettings {
    private static let WEATHER_API_KEY: String = "26877aa1445c7a079c75f4ea388e7483"
    static var INITIAL_LON: Double = 80.6081
    static var INITIAL_LAT: Double = 28.0836
    static func getOpenWeatherApiUrl(lat: Double, lon: Double) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(WEATHER_API_KEY)&units=metric"
    }
}
