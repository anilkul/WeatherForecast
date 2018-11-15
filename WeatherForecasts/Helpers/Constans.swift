//
//  Constans.swift
//  WeatherForecasts
//
//  Created by Mehmet Anıl Kul on 2.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import Foundation

let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "a6c7377af4f8db681c5d56ee69b60452"


//Asagidaki location.sharedInstance degerlerini force unwrap yaptik. Yapmazsak optional deger verirler. 

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude! )&lon=\(Location.sharedInstance.longitude!)&appid=a6c7377af4f8db681c5d56ee69b60452"


let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&appid=a6c7377af4f8db681c5d56ee69b60452"
//Download'in tamamlandigini haber vermek icin kullanilan bir type olusturduk
typealias DownloadComplete = () -> ()
