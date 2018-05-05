//
//  TableViewController.swift
//  Airport List
//
//  Created by hortune on 2018/5/5.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit
import Foundation
struct Airport {
    var country : String
    var iata : String
    var city : String
    var shortName : String
    var name : String
}

class TableViewController: UITableViewController {
    var sections: [String] = []
    var data: [[Airport]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPlistData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadPlistData(){
        let path = Bundle.main.path(forResource:"Airports Data/airports", ofType: "plist")
        let data = NSArray(contentsOfFile: path!) as? [Dictionary<String,String>]
        
        for airport in data! {
            if  !self.sections.contains(airport["Country"]!) {
                self.sections.append(airport["Country"]!)
                self.data.append([])
            }
            let indexOfsection = self.sections.index(of:airport["Country"]!)!
            self.data[indexOfsection].append(
                Airport(
                    country:airport["Country"]!,
                    iata:airport["IATA"]!,
                    city:airport["ServedCity"]!,
                    shortName:airport["ShortName"]!,
                    name:airport["Airport"]!)
            )
            
        }
        debugPrint(self.data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.data[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
//        cell.textLabel?.text = self.data[indexPath.section][indexPath.row].name
//        cell.detailTextLabel?.text = self.data[indexPath.section][indexPath.row].iata
        // Configure the cell...
        cell.airportName.text = self.data[indexPath.section][indexPath.row].name
        cell.iata.text = self.data[indexPath.section][indexPath.row].iata
        cell.city.text = self.data[indexPath.section][indexPath.row].city
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController: DetailViewController = segue.destination as! DetailViewController
            detailViewController.airportData = self.data[(tableView.indexPathForSelectedRow?.section)!][(tableView.indexPathForSelectedRow?.row)!]
            detailViewController.title = detailViewController.airportData.iata
          
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
