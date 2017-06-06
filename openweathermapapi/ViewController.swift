//
//  ViewController.swift
//  openweathermapapi
//
//  Created by Alvaro Santiesteban on 6/4/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    
    var weatherData = [DailyWeatherData]()
    var currentCity: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData{
            self.weatherTableView.reloadData()
        }
    }
    
    func setUIElements(){
        if weatherData.count > 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let todayString = dateFormatter.string(from: Date())
            let uiElements = weatherData[0]
            temperatureLabel.text = "\(uiElements.MaxTemp)"
            descriptionLabel.text = uiElements.Description
            dateLabel.text = "Today, \(todayString)"
            cityLabel.text = currentCity
            iconImageView.image = UIImage(named: uiElements.Description)
        }
        
        
        
    }
    
    func getWeatherData(completed: @escaping DownloadComplete){
        
        let methodParameters = [
            Constants.OpenWeatherMapParameterKeys.Latitude : Constants.OpenWeatherMapParameterValues.Latitude as AnyObject,
            Constants.OpenWeatherMapParameterKeys.Longitude : Constants.OpenWeatherMapParameterValues.Longitude as AnyObject,
            Constants.OpenWeatherMapParameterKeys.Count : Constants.OpenWeatherMapParameterValues.Count,
            Constants.OpenWeatherMapParameterKeys.Units : Constants.OpenWeatherMapParameterValues.Units,
            Constants.OpenWeatherMapParameterKeys.APPId : Constants.OpenWeatherMapParameterValues.APPId
            ] as [String:AnyObject]
        
        let urlString = Constants.OpenWeatherMap.APIBaseURL + escapedParameters(methodParameters)
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else{
                print("No data was returned by the request!")
                return
            }
            
            //Parse data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                self.setDailyWeatherData(parsedResult)
                
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            completed()
            
            
        }
        
        task.resume()
        
        
    }
    
    func setDailyWeatherData(_ parsedResult: [String:AnyObject]) {
        guard let weatherListDictionary = parsedResult[Constants.OpenWeatherMapResponseKeys.DayList] as? [[String:AnyObject]] else {
            print("Cannot find key '\(Constants.OpenWeatherMapResponseKeys.DayList)' in \(parsedResult)")
            return
        }
        guard let city = parsedResult["city"] as? [String:AnyObject] else {
            print("Cannot valid city")
            return
        }
        
        currentCity = "\(city["name"] ?? "" as AnyObject)"
        
        for weatherDay in weatherListDictionary{
            var minTemp: String!
            var maxTemp: String!
            var description: String!
            var stringDate: String!
            
            guard let date = Date(timeIntervalSince1970: weatherDay[Constants.OpenWeatherMapResponseKeys.Day] as! Double) as? Date else {
                print("Cannot find valid dates")
                return
            }
            
            stringDate = self.dayOfWeek(date)
            
            
            guard let weatherDictionary = weatherDay[Constants.OpenWeatherMapResponseKeys.Weather] as? [[String:AnyObject]] else {
                print("Cannot find valid weather")
                return
            }
            
            description = weatherDictionary[0]["main"] as! String
            
            guard let temperatures = weatherDay[Constants.OpenWeatherMapResponseKeys.Temperatures] as? [String:AnyObject] else{
                print("Cannot find valid temperatures")
                return
            }
            
            minTemp = "\(temperatures["min"] ?? "" as AnyObject)º"
            maxTemp = "\(temperatures["max"] ?? "" as AnyObject)º"
            
            let dailyWeatherData = DailyWeatherData(Date: stringDate, Description: description, MinTemp: minTemp, MaxTemp: maxTemp)
            weatherData.append(dailyWeatherData)
            
        }
        setUIElements()
        
    }
    
    func dayOfWeek(_ dayOfWeek: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: dayOfWeek).capitalized
    }
    
    
    
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "\(Constants.OpenWeatherMapParameterValues.Method)?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
