//
//  MeceviTableViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 24.5.21..
//

import UIKit
import ChameleonFramework
import Firebase

class MeceviTableViewController: UITableViewController {

    

    @IBOutlet var tableMatches: UITableView!
    
    var ref: DatabaseReference!
    var matchHistory = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none // da nema linija izmedju elemenata tabele
        tableView.rowHeight = 150
        navigationItem.backButtonDisplayMode = .default
        
        // sad za citanje iz baze
        ref = Database.database().reference().child("matches")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0{
                self.matchHistory.removeAll()
                
                for matches in snapshot.children.allObjects as! [DataSnapshot]{
                    let matchObject = matches.value as? [String : AnyObject]
                    let player1 = matchObject?["player1"]
                    let player2 = matchObject?["player2"]
                    let winner = matchObject?["winner"]
                    
                    let match = Match(player1: player1 as! String?, player2: player2 as! String?, winner: winner as! String?)
                    
                    self.matchHistory.append(match)
                }
                
                self.tableMatches.reloadData()
            }
        }
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // identifier je onaj identifier sto smo dali cell u main.storyboard
        
        return matchHistory.count // napravice onoliko redova u tabeli koliko mi imamo elemenata u nizu
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
        let match : Match
        match = matchHistory[indexPath.row]
        cell.textLabel?.text = "\(match.player1 ?? "")\tvs\t\(match.player2 ?? "")\tWinner \(match.winner ?? "")"
        
        
        
                        // potamnice za odredjen %. npr peti element od 10 njih ce da posvetli za 50% tj 5/10 = 50%
//        if let color = FlatYellow().lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(matchArray.count)){
//
//        }
        
        if let color = UIColor.yellow.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(matchHistory.count)){
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
