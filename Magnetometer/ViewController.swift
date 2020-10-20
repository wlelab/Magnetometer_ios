//
//  ViewController.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/14.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var magneticValueLabel : UILabel!
    @IBOutlet var diagramView : DiagramView!
    @IBOutlet var timerLabel : TimerLabel!
    @IBOutlet var rotationSpeedLabel : UILabel!
    @IBOutlet var roundLabel : RoundLabel!
    
    
    let motionManager = CMMotionManager()
    var magnetometerDataArray = [MagnetometerData]()
    var isStop = true
    
    var roundSpeedDataArray = [RoundSpeedData]()
    var roundsCountStartTime : Date?
    var lastRoundEndTime : Date?
    
    
    // MARK: - viewLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startMotionManager()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.title = "Magnetometer"
        self.view.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
        
        setupStartButtonItem()
        setupSettingButtonItem()
        setupMagneticValueLabel()
        setupTimerLabel()
        setupRoundLabel()
        setupRotationSpeedLabel()
    }
    
    func setupMagneticValueLabel() {
        magneticValueLabel.numberOfLines = 2
        magneticValueLabel.adjustsFontSizeToFitWidth = true
        magneticValueLabel.text = "Magnetic: ?"
    }
    
    func setupStartButtonItem() {
        let title = isStop ? "Start" : "Stop"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title,
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(startStop))
    }
    
    func setupSettingButtonItem() {
        if isStop {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Setting",
                                                                     style: .done,
                                                                     target: self,
                                                                     action: #selector(openSetting))
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setupTimerLabel() {
        timerLabel.text = ""
    }
    
    func setupRoundLabel() {
        roundLabel.text = ""
        roundLabel.adjustsFontSizeToFitWidth = true
        
        roundLabel.changeAction = { [weak self] _ in
            self?.computeSpeed()
        }
    }
    
    func setupRotationSpeedLabel() {
        rotationSpeedLabel.text = ""
    }
    
    
    // MARK: - Speed
    
    func computeSpeed() {
        if let lastRoundEndTime = self.lastRoundEndTime {
            let now = Date()
            let roundTimeInterval = now.timeIntervalSince(lastRoundEndTime)
            rotationSpeedLabel.text = "Round Speed: \(String(format: "%.4f sec.", roundTimeInterval))"
            self.lastRoundEndTime = now
            
            let timestamp = now.timeIntervalSince(roundsCountStartTime ?? now)
            let speedData = RoundSpeedData(timestamp: timestamp, value: roundTimeInterval)
            roundSpeedDataArray.append(speedData)
        } else {
            self.lastRoundEndTime = Date()
        }
    }
    
    
    // MARK: - Start / Stop / Round
    
    @objc func startStop() {
        if isStop {
            runAction()
        } else {
            let cancelAvtion = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Stop", style: .destructive) { _ in
                self.runAction()
            }
            
            let controller = UIAlertController(title: "Stop?", message: "", preferredStyle: .alert)
            controller.addAction(cancelAvtion)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    func runAction() {
        isStop = !isStop
        setupStartButtonItem()
        setupSettingButtonItem()
        magnetometerDataArray.removeAll()
        roundSpeedDataArray.removeAll()
        
        roundLabel.stopUpdate()
        
        if isStop {
            timerLabel.stop()
            rotationSpeedLabel.textColor = .gray
        } else {
            roundLabel.recount()
            roundsCountStartTime = nil
            lastRoundEndTime = nil
            rotationSpeedLabel.text = ""
            
            timerLabel.countdownDoneAction = { [weak self] in
                self?.roundLabel.textColor = UIColor(white: 0.13, alpha: 1)
                self?.computeLevelValue()
            }
            timerLabel.start()
        }
    }
    
    func computeLevelValue() {
        magnetometerDataArray.sort { $0.value > $1.value }
        let levelSize = Int(magnetometerDataArray.count / 10)
        
        roundLabel.topLevelValue = magnetometerDataArray[levelSize].value
        roundLabel.bottomLevelValue = magnetometerDataArray[magnetometerDataArray.count - levelSize].value
        
        roundLabel.text = "Round: \(roundLabel.roundFormatString(0))"
        
        //print("top:\(String(format: "%.3f", roundLabel.topLevelValue!)), bottom:\(String(format: "%.3f", roundLabel.bottomLevelValue!))")
        
        roundsCountStartTime = Date()
    }
    
    
    // MARK: - Setting Page
    
    @objc func openSetting() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsTableViewController
        show(vc, sender: self)
    }
    
    
    // MARK: - Motion Manager
    
    func startMotionManager() {
        motionManager.magnetometerUpdateInterval = 1/60
        
        if motionManager.isMagnetometerAvailable {
            motionManager.startMagnetometerUpdates(to: OperationQueue()) { (magnetometerData, error) in
                guard let data = magnetometerData, error == nil else {
                    print("ERROR: \(error!.localizedDescription)")
                    return
                }
                
                let xval = data.magneticField.x
                let yval = data.magneticField.y
                let zval = data.magneticField.z
                let magneticValue = sqrt((xval * xval) + (yval * yval) + (zval * zval))
                let timestamp = data.timestamp
                let mData = MagnetometerData(timestamp: timestamp, value: magneticValue)
                
                print(">> x: \(xval), y: \(yval), z: \(zval)")
                print("   timestamp: \(timestamp)")
                
                
                DispatchQueue.main.async {
                    self.diagramView.addData(mData)
                    
                    if self.isStop == false {
                        self.magnetometerDataArray.append(mData)
                    }
                    
                    let xstr = String(format: "%.1f", xval)
                    let ystr = String(format: "%.1f", yval)
                    let zstr = String(format: "%.1f", zval)
                    let magneticStr = String(format: "%.1f", magneticValue)
                    self.magneticValueLabel.text = "Magnetic: \(magneticStr)\n(x:\(xstr), y:\(ystr), z:\(zstr))"
                    
                    self.roundLabel.updateRoundWith(magneticValue: magneticValue)
                }
            }
        } else {
            self.magneticValueLabel.text = "Magnetometer not available!"
        }
    }
    
}

