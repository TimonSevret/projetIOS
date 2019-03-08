//
//  WeatherData.swift
//  projetAppliAvancer
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit

class WeatherData: Codable {
    struct Coord: Codable{
        var lon: Double?
        var lat: Double?
    }
    var coord: Coord

    struct Weather: Codable{
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    var weather: [Weather]
    
    struct Main: Codable{
        var temp: Double?
        var pressure: Double?
        var humidity: Double?
        var temp_min: Double?
        var temp_max: Double?
        var sea_level: Double?
        var grnd_level: Double?
    }
    var main: Main
    
    struct Wind: Codable{
        var speed: Double?
        var deg: Double?
    }
    var wind: Wind
    var id: Int?
    var name: String?
    
    static func decode(data: Data) -> WeatherData?{
        do{
            let weather =  try JSONDecoder().decode(WeatherData.self, from: data)
            return weather
        }catch let jsonError{
            print(jsonError)
        }
        return nil
    }

}
