//
//  SettingsSection.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 26.5.21..
//

import Foundation

enum SettingsSection: Int, CaseIterable, CustomStringConvertible{
    typealias RawValue = Int
    
    case Audio
    
    var description: String{
        switch self {
        case .Audio:
            return "Audio"
        default:
            return "Settings"
        }
    }
    
}

enum AudioOptions: Int, CaseIterable, CustomStringConvertible{
    case sounds
    case music
    
    var description: String{
        switch self {
        case .sounds: return "Sounds"
        case .music : return "Music"
        default: return "Music"
        }
    }
}


