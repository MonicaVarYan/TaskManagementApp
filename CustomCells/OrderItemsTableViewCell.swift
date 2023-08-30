//
//  OrderItemsTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-10.
//

import UIKit

class OrderItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var orderSegmented: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    var orderOnTop: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderOnTop = defaults.bool(forKey: "OrderTop")
        orderSegmented.selectedSegmentIndex = orderOnTop ? 0 : 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func orderSegmentedTapped(_ sender: Any) {
        
        switch orderSegmented.selectedSegmentIndex {
            
        case 0: defaults.set(true, forKey: "OrderTop")
            
        case 1: defaults.set(false, forKey: "OrderTop")
            
        default: return
            
        }
    }
    
}
