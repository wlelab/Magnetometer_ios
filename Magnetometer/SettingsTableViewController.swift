//
//  SettingsTableViewController.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/16.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    // MARK: - viewLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        self.title = "Settings"
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    override  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Timer"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Countdown Seconds"
            let seconds = SettingsHelper.countdownSeconds()
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
            label.text = "\(seconds)　❯"
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = UIColor(white: 0.5, alpha: 1)
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            cell.accessoryView = label
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }


    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "CountdownSecondsVC") as! CountdownSecondsTableViewController
            show(vc, sender: self)
        default:
            break
        }
    }

}
