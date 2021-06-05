//
//  Reci.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 15.4.21..
//

import Foundation

struct Reci{

    var words = ["computer keyboard", "orange", "water bottle", "pomegranate", "analog clock", "backpack", "computer mouse", "calendar", "mug", "scissors", "spoon", "lamp", "chocolate", "flower", "helmet", "wallet", "truck", "soap", "perfume", "sticky note", "camera", "bread", "tweezers", "towel", "hanger", "bed", "stop sign", "nail clippers", "toilet", "toothbrush", "apple", "banana", "watch", "watermelon", "plate", "glasses", "key", "television", "deodorant", "shovel", "broccoli",  "piano", "door"]

    
    mutating func vratiRandomRec() -> String{
        //let randomInt = Int.random(in: 0...reci.count-1)
        //return reci[randomInt]
        var word : String = ""
        words.shuffle()
        
        if !words.isEmpty{
            word = words.removeLast()
        }
        return word
    }
}
