//
//  TableViewController.swift
//  openweathermapapi
//
//  Created by Alvaro Santiesteban on 6/4/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import UIKit

extension ViewController:  UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count > 1 ? weatherData.count - 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        cell.minTempTextView.text = weatherData[indexPath.row + 1].MinTemp
        cell.maxTempTextView.text = weatherData[indexPath.row + 1].MaxTemp
        cell.dayTextView.text = weatherData[indexPath.row + 1].Date
        cell.descriptionTextView.text = weatherData[indexPath.row + 1].Description
        cell.iconImageView.image = UIImage(named: "\(weatherData[indexPath.row + 1].Description) Mini")

        return cell
    }

}
