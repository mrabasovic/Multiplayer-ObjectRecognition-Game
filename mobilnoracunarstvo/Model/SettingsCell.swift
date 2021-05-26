//
//  SettingsCell.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 26.5.21..
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        //switchControl.isOn = defaults.bool(forKey: <#T##String#>)
        
        switchControl.onTintColor = UIColor.yellow
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        //switchControl.actions(forTarget: switchChanged(sender: switchControl), forControlEvent: .valueChanged)
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
                                        // ZNACI SVAKI put kad je value changed tj pritisnuto dugme poziva se fja handleSwitchAction /////// #selector(handleSwitchAction)
        return switchControl
    }()
    
    // kreiramo standardni userDefaults
    let defaults = UserDefaults.standard
    
    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.tag == 0{
            defaults.setValue(switchControl.isOn, forKey: "soundsButton")
        }else{
            defaults.setValue(switchControl.isOn, forKey: "musicButton")
        }
        
    }
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
