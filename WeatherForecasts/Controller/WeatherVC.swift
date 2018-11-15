//
//  ViewController.swift
//  WeatherForecasts
//
//  Created by Mehmet Anıl Kul on 1.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

//protokolleri ekliyoruz
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentTempLbl: UILabel! //su anki sicaklik
    @IBOutlet weak var dateLbl: UILabel! //tarih
    @IBOutlet weak var locationLbl: UILabel! //lokasyon
    @IBOutlet weak var currentWeatherImg: UIImageView! //su anki hava resmi
    @IBOutlet weak var currentWeatherTypeLbl: UILabel! // hava durumu label'i
    @IBOutlet weak var tableView: UITableView! // gunluk forecast icin tableview
    
    //CLLocationManager turunde bir locationManager degiskeni tanimladik. Ayni zamanda su anki lokasyonu belirlemek amacli currentLocation degiskeni de tanimladik
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!         // su anki hava
    var forecast: Forecast!
    var forecasts = [Forecast]()                // periyodik hava durumu tablosu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CLLocationManager protokolin aktif edelim
        locationManager.delegate = self
        
        //lokasyon belirleme hassasiyetini ayarlayalim
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // When in use Allow penceresi icin
        locationManager.requestWhenInUseAuthorization()
        
        // Konum degisikliklerini tara
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //su anki hava durumunu initialize edelim
        currentWeather = CurrentWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    // Burada lokasyon authorize isleminin gerceklesip gerceklesmemesi durumuna gore yapilacaklari belirliyoruz
    func locationAuthStatus() {
        
        //when in use olayi ile authorization alinmis ise
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            //su anki loaksyonu ayarla
            currentLocation = locationManager.location
            
            //olusturdugumuz Location.swift dosyasinda yer alan Location class'inda belirledigimiz sharedInstance metodunu kullanarak latitude ve longitude degiskenlerine enlem ve boylam degerlerini atiyoruz
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            print(Location.sharedInstance.latitude, Location.sharedInstance.longitude) //test
            
            // su anki hava durumunu indir. Burada fonksiyonun adini yazdigimizda autofill'de braket icerisinde { code } cikacaktir. Bu, fonksiyon icerisinde download complete olduktan sonra UI'i update etmemiz icin gereken kodu yazmamiza imkan verir
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {  // UI'i update etmeden once forecast'i de indirelim
                    self.updateMainUI()
                }
            }
        } else {
            //authorization sorulmadiysa sor
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus() // fonskiyona recursive olarak tekrar don
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //TableView icin forecast data'si indiriliyor.
        let forecastURL = URL(string: FORECAST_URL)!
        //Alamofire kullanarak URL'deki JSON data'sini aliyoruz
        Alamofire.request(forecastURL).responseJSON{
            response in // response veriyoruz
            let result = response.result // result degiskeni bizim response'umuzun result'i
            
            // Dictionary turunde bir dict degiskeni tanimladik ve bunu result.value yani sonucla listelenen degerlere esitledik. Dictionary'nin barindirdigi key ve value tiplerini de < > icerisinde belirttik
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                // dict ile alinan sonuc icersinde list isimli key'i acalim. Bu key bir string key ve anyObject value barindiran dictionary'lerden olusan bir array oldugundundan [ ] icerisinde belirtildi
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                    
                    
                    // ulastigimiz api'da listteki her bir eleman birer dictionary. Her birine obj diyelim
                    for obj in list {
                        
                        // Forecast classinda initializer olan weatherDict(bu da dictionary tipinden) degiskenini, su anki obj yapip istedigimiz degerleri alarak yeni bir forecast degerine esitliyoruz
                        let forecast = Forecast(weatherDict: obj)
                        
                        //son durumda istedigimiz bilgilere sahip oldugumuz forecast'i, forecasts[] arrayine eleman olarak ekliyoruz
                        self.forecasts.append(forecast)
                    }
                    //Ilk hava durumunu current_weather_url ile aldigimiz icin 2. gunden baslayaim
                    self.forecasts.remove(at: 0)
                    
                    //loop tamamlandiktan sonra tableView'a reset atalim bilgiler gorunsun.
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            // configureCell fonksiyonu ile veriyi UI'a aktariyoruz
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell() //bir sorun cikarsa bos weather cell'e don
        }
    }
    
    func updateMainUI() {
        dateLbl.text = currentWeather.date
        currentTempLbl.text = "\(currentWeather.currentTemp)°C" // currentTemp double oldugu icin string icine aldik
        currentWeatherTypeLbl.text = currentWeather.weatherType
        locationLbl.text = currentWeather.cityName
        currentWeatherImg.image = UIImage(named: currentWeather.weatherType)
        
        
    }
    
}







