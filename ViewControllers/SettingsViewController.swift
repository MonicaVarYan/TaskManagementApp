//
//  SettingsViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-06.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Theme" : "Order"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell",
                                                     for: indexPath) as! ThemeTableViewCell
            cell.selectionStyle = .none
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                         for: indexPath) as! OrderItemsTableViewCell
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "separateCell",
                                                         for: indexPath) as! SeparateItemsTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "themeColorSegue", sender: indexPath)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "themeColorSegue"){
            _ = segue.destination as! ThemeCollectionViewController
        }
    }

}
