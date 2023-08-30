//
//  ListsTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-05.
//

import UIKit

class ListsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
