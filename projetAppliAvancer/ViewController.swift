//
//  ViewController.swift
//  projetAppliAvancer
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit
import MapKit
import CoreImage

//gere la premiere vue, celle qui offre la meteo ect
class ViewController: UIViewController {
    
    let appid = "2d9c0ddd9aea6414829c20fdf26def06"

    
    
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
        var name = ""
        if isfavorite(){
            name = "favPlein.png"
        }else{
            name = "favVide.png"
        }
        let loc = getPosition()
        getData(localisation:loc)
        favorite.image = UIImage(named: name)
    }
    
    func isfavorite() -> Bool{
        //TODO
        return true
    }
    
    func getPosition() -> CLLocationCoordinate2D{
        //TODO
        return CLLocationCoordinate2D(latitude: 47.902964,longitude: 1.909251)
    }
    
    func getData(localisation :CLLocationCoordinate2D){
        if let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(localisation.latitude)&lon=\(localisation.longitude)&appid=\(appid)"){
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

}
