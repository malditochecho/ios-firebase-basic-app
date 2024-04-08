//
//  SettingsViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var table: UITableView!
    
    // MARK: Variables
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    // MARK: IBActions
    @IBAction func btnSignOut(_ sender: Any) {
        AuthProvider.logout { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Extensions
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(
            style: .value1,
            reuseIdentifier: "cell")
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Logged in as:"
            cell.detailTextLabel?.text = Auth.auth().currentUser?.email
            return cell
        case 1:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        case 2:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        case 3:
            cell.textLabel?.text = "Version:"
            cell.detailTextLabel?.text = "v0.1.8"
            return cell
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

