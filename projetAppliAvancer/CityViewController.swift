//
//  CityViewController.swift
//  projetAppliAvancer
//
//  Created by tp on 11/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    var selectedCity :String = ""
    
    @IBOutlet weak var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        test.text = selectedCity
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
