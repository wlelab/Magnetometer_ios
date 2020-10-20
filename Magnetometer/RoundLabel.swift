//
//  RoundLabel.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/16.
//

import UIKit

class RoundLabel: UILabel {
    
    var topLevelValue : Double?
    var bottomLevelValue : Double?
    var count = -1
    var canCount = false
    var changeAction : ((_ count: Int) -> Void)?
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func stopUpdate() {
        canCount = false
        topLevelValue = nil
        bottomLevelValue = nil
        self.textColor = .gray
    }
    
    func recount() {
        self.count = 0
        self.text = ""
    }
    
    func updateRoundWith(magneticValue: Double) {
        if let topValue = topLevelValue, let bottomValue = bottomLevelValue {
            if magneticValue < topValue && magneticValue > bottomValue {
                return
            }
            
            if magneticValue >= topValue && canCount == true {
                canCount = false
                count += 1
                self.text = "Round: \(roundFormatString(count))"
                
                if let action = changeAction {
                    action(count)
                }
            }
            
            if canCount == false && magneticValue <= bottomValue {
                canCount = true
            }
        }
    }
    
    func roundFormatString(_ round: Int) -> String {
        if round < 10000 {
            return String(format: "%04d", round)
        }
        if round < 100000 {
            return String(format: "%05d", round)
        }
        return "\(round)"
    }
    
}
