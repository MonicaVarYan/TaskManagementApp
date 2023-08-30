//
//  SeparateItemsTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-10.
//

import UIKit

class SeparateItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var separateItems: UISwitch!
    
    let defaults = UserDefaults.standard
    var isSeparate: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separateItems.onTintColor = UIColor.appColor(.Dark)
        isSeparate = defaults.bool(forKey: "SeparateItems")
        separateItems.isOn = isSeparate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func separateItemTapped(_ sender: Any) {
        
        if separateItems.isOn {
            defaults.set(true, forKey: "SeparateItems")
        }else {
            defaults.set(false, forKey: "SeparateItems")
        }
    }
}
