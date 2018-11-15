//
//  WeatherCell.swift
//  WeatherForecasts
//
//  Created by Mehmet Anıl Kul on 4.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        lowTemp.text = "\(forecast.lowTemp)°C"
        highTemp.text = "\(forecast.highTemp)°C"
        weatherType.text = forecast.weatherType
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayLbl.text = forecast.date
    }

}
