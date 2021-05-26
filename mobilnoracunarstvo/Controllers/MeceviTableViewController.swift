//
//  MeceviTableViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 24.5.21..
//

import UIKit
import ChameleonFramework

class MeceviTableViewController: UITableViewController {

    
    let matchArray = ["MladenR98 vs Nex-65 Winner: MladenR98", "Mix vs Nex225 Winner: Mix"]//[Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none // da nema linija izmedju elemenata tabele
        tableView.rowHeight = 80
        navigationItem.backButtonDisplayMode = .default
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // identifier je onaj identifier sto smo dali cell u main.storyboard
        
        return matchArray.count // napravice onoliko redova u tabeli koliko mi imamo elemenata u nizu
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
        cell.textLabel?.text = matchArray[indexPath.row]
        
                        // potamnice za odredjen %. npr peti element od 10 njih ce da posvetli za 50% tj 5/10 = 50%
//        if let color = FlatYellow().lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(matchArray.count)){
//
//        }
        
        if let color = UIColor.yellow.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(matchArray.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true) // ova linija je za tekst
        }
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
