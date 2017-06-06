//
//  WeatherTableViewCell.swift
//  openweathermapapi
//
//  Created by Alvaro Santiesteban on 6/4/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var maxTempTextView: UILabel!
    @IBOutlet weak var minTempTextView: UILabel!
    @IBOutlet weak var dayTextView: UILabel!
    @IBOutlet weak var descriptionTextView: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
