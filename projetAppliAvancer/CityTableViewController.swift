//
//  CityTableViewController.swift
//  projetAppliAvancer
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 tpxcode. All rights reserved.
//

import UIKit

class CityTableViewController: UITableViewController {
 
    @IBOutlet weak var CityField: UITextField!
    //juste import la view pour le clavier du textfield ?
    

    var tableaucity2 = [City]()
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "CityTableViewCell"
    
    let fichier = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Cities.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id  >> WHY, j'arrive pas à la retune ?
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let backgroundimage = UIImage(named: "screen-2.jpg")
        let imageview = UIImageView(image: backgroundimage)
        //imageview.contentMode = .scaleAspectFit selon image ?
        self.tableView.backgroundView = imageview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        print(fichier) //in fine faire une classe spéciale pour les opérations de stockage
 
        // Récupération des données depuis le fichier
        do {
            let recup = try Data(contentsOf: fichier!)
            let decoder = PropertyListDecoder()
            tableaucity2 = try decoder.decode([City].self, from: recup)
        } catch {
            print("Echec lecture depuis le fichier : \(error)")
        }
        
        for city in tableaucity2 {
            print(city.name)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationcity.rightBarButtoncity = self.editButtoncity
    }
    

    @IBAction func AddButton(_ sender: UIButton) {
        do {
            let recup = try Data(contentsOf: fichier!)
            let decoder = PropertyListDecoder()
            tableaucity2 = try decoder.decode([City].self, from: recup)
        } catch {
            print("Echec lecture depuis le fichier : \(error)")
        }
        let city=City();
        if(!CityField.text!.isEmpty){
            city.name=CityField.text!; }
        city.favorite=false; //a mettre en guard
        tableaucity2.append(city) //do catch?
        CityField.text = "";
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(tableaucity2)
            try data.write(to: fichier!)
        } catch {
            print("Echec écriture dans le fichier : \(error)")
        }
        self.tableView.reloadData()
        //self.refresher ??
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableaucity2.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     // create a new cell if needed or reuse an old one
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? CityTableViewCell else { fatalError("Wrong dequeued cell instance") }

         // set the text from the data model
         cell.textLabel?.text = self.tableaucity2[indexPath.row].name
        
         cell.cameraButton.setTitle(self.tableaucity2[indexPath.row].name, for: .normal)

         return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = .clear transparent
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified city to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableaucity2.remove(at:indexPath.row)
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(tableaucity2)  //a voir si y a moins bourrin
                try data.write(to: fichier!)
            } catch {
                print("Echec écriture dans le fichier : \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMeteo", sender: self)
        /*let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = StoryBoard.instantiateViewController(withIdentifier: "meteoView") as! ViewController
        tableView.deselectRow(at: indexPath, animated: true)
        
        VC.selectedCity = self.tableaucity2[indexPath.row].name
        self.navigationController?.pushViewController(VC, animated: true)*/
    }
    
    @IBAction func viewcity(_ sender: UIButton) {  //camerabutton
        performSegue(withIdentifier: "segue2", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segue2"){
            // Get the new view controller using segue.destination.
            let destVC : CityViewController = segue.destination as! CityViewController
        
            // Pass the selected object to the new view controller.
            let camera = sender as! UIButton
                //nom de la ville correspondante
            destVC.selectedCity = camera.title(for: .normal)!
        }
        if(segue.identifier == "toMeteo"){                                               //mettre la bonne segue
            let destVC : ViewController = segue.destination as! ViewController  //mettre le bon nom
            let indexPath = tableView.indexPathForSelectedRow
            destVC.selectedCity = self.tableaucity2[indexPath!.row].name                //mettre le bon nom de l'attribut
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the city to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
