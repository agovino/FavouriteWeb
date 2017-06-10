//
//  ViewController.swift
//  FavouriteWeb
//
//  Created by Line Stettler & Marco Agovino on 10.06.17.
//  Copyright © 2017 Stettler & Agovino. All rights reserved.
//

import UIKit

class UrlListTableViewController: UITableViewController {

    // Tabelle einbinden -> ein Array aus FavouriteWeb
    var urlList = [FavouriteWeb](){
        // propertie observer
        didSet {
            tableView.reloadData()
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  hier wird das ganze gefüllt (urlResource von AppDelegate...)
        //  Damit werden die Werte auf jedenfalls gefüllt.
        urlList = appDelegate.urlResource.getList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // warning berücksichtigen
        // ein leeres Array
        urlList = [FavouriteWeb]()
    }
    
    // number of Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // die Listenlänge zurückgeben
        return urlList.count
    }
    // Table View Cell mit Identifier: urlCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Holen der Cell aus der queue
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        
        // favourit-Objekt mit name und url
        let superUrl = urlList[indexPath.row]
        
        // Cell anzeigen mit textlabel
        // textlabel ist ein optional ==> ?
        cell.textLabel?.text = superUrl.name
        
        return cell
    }
    
    // func prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // wenn identifier == "addURL_segue"
        if segue.identifier == "addURL_segue"{
            let dst = segue.destination as! AddViewController
            dst.delegate = self
        }
        // wenn identifier == "detailView"
        if segue.identifier == "detailView" {
        let dst = segue.destination as! WebViewController
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            dst.superUrl = urlList[indexPath.row]
       }
    }
}
extension UrlListTableViewController: FavouriteWebDelegate {
    func superUrlAdded(withName:String, andUrl:String){
        let newUrl = FavouriteWeb(name:withName, url:andUrl)
        urlList.append(newUrl)
    }
}


