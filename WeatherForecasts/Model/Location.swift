//
//  Location.swift
//  WeatherForecasts
//
//  Created by Mehmet Anıl Kul on 4.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location() //sharedInstance isminde, yine Location class'inda bir degisken tanimliyoruz. Bu sayede, Location.latitude kullanilamadigi icin Location.sharedInstance.latitude gibi asagidaki tanimlanan degiskenleri kullanabiliriz.
    private init() {} // initializer yok formalite
    
    var latitude: Double!
    var longitude: Double!
    
}
