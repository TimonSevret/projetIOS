//
//  ViewController.swift
//  projetAppliAvancer
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit
import MapKit

//gere la premiere vue, celle qui offre la meteo ect
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let appid = "2d9c0ddd9aea6414829c20fdf26def06"
    var selectedCity :String?
    


    @IBOutlet weak var favorite: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var villeLabel: UILabel!
    @IBOutlet weak var VitVentLabel: UILabel!
    @IBOutlet weak var DirVentLabel: UILabel!
    @IBOutlet weak var humiditeLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var TempImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let city = selectedCity{
            favorite.image = UIImage(named: "favVide.png")
            getPosition(ville: city)
        }else{
            let userDefaults = UserDefaults.standard
            let cityName = userDefaults.string(forKey: "favorite")
            if let city = cityName {
                favorite.image = UIImage(named: "favPlein.png")
                getPosition(ville: city)
            }else{
                favorite.image = UIImage(named: "favVide.png")
                getPosition()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        if let loc = manager.location{
            geocoder.reverseGeocodeLocation(loc){
                (placeMark,error) in
                self.selectedCity = placeMark![0].name
                self.getData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getPosition(){
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestLocation()
    }
    
    func getPosition(ville: String){
        selectedCity = ville
        getData()
    }
    
    func getData(){
        if let city = selectedCity {
            if let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appid)"){
                URLSession.shared.dataTask(with: url){(data,response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    let weatherData = WeatherData.decode(data:data!)
                    DispatchQueue.main.async {
                        self.populate(weather: weatherData!)
                    }
                    }.resume()
            }
        }
    }

    func populate(weather: WeatherData){
        dateLabel.text = "\(Date())"
        villeLabel.text = "\(weather.name ?? "error")"
        humiditeLabel.text = "Humidité \n \(weather.main.humidity ?? -1)"
        DirVentLabel.text = "Dir - Vent \n \(weather.wind.deg ?? -1)"
        VitVentLabel.text = "Vit - Vent \n \(weather.wind.speed ?? -1)"
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 1
        let temperature: Double = (weather.main.temp ?? -1) - 273.15
        TemperatureLabel.text = "\(nf.string(from: NSNumber(value: temperature))!) °C"
        loadImage(id_temps: weather.weather[0].id ?? -1)
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
        }
    }
    
    func loadImage(id_temps: Int){
        var name: String
        switch (id_temps) {
            
        case 0...300 :
            name = "tstorm1.png"
            
        case 301...500 :
            name = "light_rain.png"
            
        case 501...600 :
            name = "shower3.png"
            
        case 601...700 :
            name = "snow4.png"
            
        case 701...771 :
            name = "fog.png"
            
        case 772...799 :
            name = "tstorm3.png"
            
        case 800 :
            name = "sunny.png"
            
        case 801...804 :
            name = "cloudy2.png"
            
        case 900...903, 905...1000  :
            name = "tstorm3.png"
            
        case 903 :
            name = "snow5.png"
            
        case 904 :
            name = "sunny.png"
            
        default :
            name = "chi_pas.png"
        }
        name = "\(name)"
        TempImage.image = UIImage(named: name)
    }

    func isFavorite(userDefaults: UserDefaults) -> Bool{
        let fav = userDefaults.string(forKey: "favorite")
        return selectedCity == fav
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if isFavorite(userDefaults: userDefaults) {
            userDefaults.removeObject(forKey: "favorite")
            favorite.image = UIImage(named: "favVide.png")
        }else{
            userDefaults.set(selectedCity,forKey: "favorite")
            favorite.image = UIImage(named: "favPlein.png")
        }
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.setNeedsDisplay()
        }
    }
}
