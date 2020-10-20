//
//  CountdownSecondsTableViewController.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/16.
//

import UIKit

class CountdownSecondsTableViewController: UITableViewController {
    
    
    // MARK: - viewLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        setup()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        self.title = "Choose Seconds"
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsHelper.countdownSecondsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondsCell", for: indexPath)
        cell.selectionStyle = .none
        
        let seconds = SettingsHelper.countdownSecondsArray[indexPath.row]
        cell.textLabel?.text = "\(seconds)"
        
        if seconds == SettingsHelper.countdownSeconds() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    

    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seconds = SettingsHelper.countdownSecondsArray[indexPath.row]
        if SettingsHelper.saveCountdownSeconds(seconds) {
            self.tableView.reloadData()
        }
    }

}
