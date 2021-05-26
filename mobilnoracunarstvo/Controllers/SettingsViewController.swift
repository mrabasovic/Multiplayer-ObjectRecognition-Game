//
//  SettingsViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 26.5.21..
//

import UIKit

private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else {return 0}
        
        switch section {
        case .Audio: return AudioOptions.allCases.count
        default: return 0
        }
    }
    
    let setCell = SettingsCell()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        cell.backgroundColor = UIColor(hexString: "#363737")
        cell.selectionStyle = .none // da ne pobeli kad dodirnemo celiju ali oped da mogu da pritisnem dugme
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .Audio:
            let audio = AudioOptions(rawValue: indexPath.row)
            cell.textLabel?.text = audio?.description
            cell.textLabel?.textColor = UIColor.white
        }
    
        // da obelezi switch dugmad siframa 0 i 1 da bismo znali koji od njih je pritisnut
        
        cell.switchControl.tag = indexPath.row
        
        // ovo ispod je da kad ugasimo aplikaciju da opet ostane onako kako je pritisnuto
        switch cell.switchControl.tag {
        case 0: cell.switchControl.isOn = setCell.defaults.bool(forKey: "soundsButton")
        case 1: cell.switchControl.isOn = setCell.defaults.bool(forKey: "musicButton")
        default:
            return cell
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.black
        title.text = SettingsSection(rawValue: section)?.description //"Audio"
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.separatorColor = UIColor.white
        tableView.backgroundColor = UIColor(hexString: "#363737")
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }

}

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
//        return cell
//    }
//
//
//}
