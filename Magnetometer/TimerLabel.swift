//
//  TimerLabel.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/16.
//

import UIKit

class TimerLabel: UILabel {
    
    var myTimer : Timer?
    var checkTime : Date?
    
    var countdownSeconds = 30
    var countdownDoneAction : (() -> Void)?
    var isRunCountdownDoneAction = false
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func start() {
        self.text = ""
        checkTime = nil
        isRunCountdownDoneAction = false
        countdownSeconds = SettingsHelper.countdownSeconds()
        
        myTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            if let time = self?.checkTime {
                self?.displayTime(time)
            } else {
                self?.checkTime = Date()
            }
        }
    }
    
    func stop() {
        myTimer?.invalidate()
        myTimer = nil
        self.textColor = .gray
    }
    
    
    func displayTime(_ time: Date) {
        let timeInterval = Date().timeIntervalSince(time)
        self.textColor = UIColor(white: 0.13, alpha: 1)
        
        if timeInterval > Double(countdownSeconds + 1) {
            let totalMinutes = Int(timeInterval/60)
                        
            let seconds = Int(timeInterval) % 60
            let hours = Int(totalMinutes/60)
            let minutes = totalMinutes % 60
            
            let hrMinSecStr = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            self.text = hrMinSecStr
        } else {
            self.textColor = .systemRed
            
            let seconds = Int(timeInterval) % 60
            let countSec = countdownSeconds - seconds
            self.text = "\(countSec > 0 ? countSec : 0)"
            
            if seconds >= countdownSeconds {
                if let action = countdownDoneAction, isRunCountdownDoneAction == false {
                    isRunCountdownDoneAction = true
                    action()
                    countdownDoneAction = nil
                }
            }
        }
    }
    
}
