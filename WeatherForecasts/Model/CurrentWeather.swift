//
//  CurrentWeather.swift
//  WeatherForecasts
//
//  Created by Mehmet Anıl Kul on 2.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!  
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        // Belirledigimiz tarihi string olarak alalim
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        
        return _currentTemp
    }
    
    //Download weather data. plist icinde App Transport Securty ve Allow Arbitary YES yapmayi unutmayalim
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON {
            response in
            let result = response.result
            print(CURRENT_WEATHER_URL)
            print(FORECAST_URL)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                //JSON'un icindeki name bolumunu ele alalim. name kismi her zaman bir string olmakta. Bu yuzden String'e cast ettik
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                // weather kismi da bir array oldugu icin "arrayin icerisinde" string key, any value seklinde cast edelim
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                    // ulasacagimiz array elemani(ki o eleman da bir array) weather array'inde 0. index yani ilk eleman(baska eleman da yok gerci). String oldugu icin string casti yapalim
                    if let main = weather[0]["main"] as? String{
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    if let currentTempreture = main["temp"] as? Double {
                        let kelvinToCelcius = (currentTempreture - 273.15)
                        
                        //virgulden sonra kac basamak gosterilecek
                        let roundendTemp = Double(round(10 * kelvinToCelcius)/10)
                        self._currentTemp = roundendTemp
                        print(self._currentTemp)    
                    }
                }
            }
           completed() 
        }
    }  
}




