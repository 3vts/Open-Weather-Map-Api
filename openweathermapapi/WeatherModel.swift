//
//  WeatherModel.swift
//  openweathermapapi
//
//  Created by Alvaro Santiesteban on 6/4/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import Foundation
import MapKit

typealias DownloadComplete = () -> ()
let locManager = CLLocationManager()

struct DailyWeatherData {
    var Date: String
    var Description: String
    var MinTemp: String
    var MaxTemp: String
}


struct Constants {
    
    // MARK: OpenWeatherMap
    struct OpenWeatherMap {
        static let APIBaseURL = "http://api.openweathermap.org/data/2.5/forecast/"
    }
    
    // MARK: OpenWeatherMap Parameter Keys
    
    struct OpenWeatherMapParameterKeys {
        static let APPId = "appid"
        static let Count = "cnt"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Units = "units"
    }
    
    // MARK: OpenWeatherMap Parameter Values
    
    struct OpenWeatherMapParameterValues {
        static let Method = "daily"
        static let APPId = "b25ac7dba453733bc381f4675dfd5a9a"
        static let Count = "16"
        static let Units = "metric"
        static var Latitude: String {
            return String(getLocation().Latitude)
        }
        static var Longitude: String {
            return String(getLocation().Longitude)
        }
    }
    
    // MARK: OpenWeatherMap Response Keys
    
    struct OpenWeatherMapResponseKeys {
        static let Code = "cod"
        static let DayList = "list"
        static let Temperatures = "temp"
        static let Day = "dt"
        static let Weather = "weather"
    }
    
    // MARK: OpenWeatherMap Response Values
    
    struct OpenWeatherMapResponseValues {
        static let Code = 200
    }
    
}

func getLocation() -> (Latitude: Double, Longitude: Double) {
    
    locManager.requestWhenInUseAuthorization()
    locManager.startMonitoringSignificantLocationChanges()
    let currentLocation: CLLocation!
    if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
        currentLocation = locManager.location
        return (currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
    }else{
        locManager.requestWhenInUseAuthorization()
        return(0.0, 0.0)
    }
    
}
