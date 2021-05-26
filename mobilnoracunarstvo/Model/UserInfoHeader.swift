//
//  UserInfoHeader.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 26.5.21..
//

import Foundation
import UIKit

class UserInfoHeader: UIView {
    
    let game = GameCenterHelper()
    
    // MARK: - Properties
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        //label.text = "Tony Stark"
        label.text = "Settings"
        label.textColor = UIColor.yellow
        label.font = UIFont.systemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
