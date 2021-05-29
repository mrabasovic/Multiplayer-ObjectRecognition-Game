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
        tableView.rowHeight = 90
        navigationItem.backButtonDisplayMode = .default
        tableView.frame = tableView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        tableView.backgroundColor = UIColor.darkGray
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {

        return matchHistory.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // identifier je onaj identifier sto smo dali cell u main.storyboard
        
        //return matchHistory.count // napravice onoliko redova u tabeli koliko mi imamo elemenata u nizu
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath)
        let match : Match
        match = matchHistory[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(match.player1 ?? "")  vs  \(match.player2 ?? "")\nWinner - \(match.winner ?? "")"
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name:"Avenir", size:17)
        
        cell.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        cell.layer.cornerRadius = 10
        
        
        
        if let color = HexColor("#FFFF00")?.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(matchHistory.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true) // ova linija je za tekst
        }
        
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.darkGray
        return header
    }
}

