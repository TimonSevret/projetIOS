//
//  CityViewController.swift
//  projetAppliAvancer
//
//  Created by tp on 11/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CityViewController: UIViewController {

    var selectedCity :String = ""

    @IBOutlet weak var carte: MKMapView!
    @IBOutlet weak var pileImage: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(selectedCity){
            (placeMark,error) in
            let location = placeMark![0].location?.coordinate
            let latDelat:CLLocationDegrees = 0.05
            let lonDelat:CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelat, longitudeDelta: lonDelat)
            let region = MKCoordinateRegion(center: location!,span: span)
            self.carte.setRegion(region, animated: true)
        }
        carte.frame = CGRect(x:0,y:30, width: self.view.frame.width, height: self.view.frame.height*0.66)
        
        var imageView = UIImageView()
        imageView.image = UIImage(named:"favPlein.png")
        pileImage.addArrangedSubview(imageView)
        imageView = UIImageView()
        imageView.image = UIImage(named:"favVide.png")
        pileImage.addArrangedSubview(imageView)
    }

}
