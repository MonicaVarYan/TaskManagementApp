//
//  ThemeTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-10.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImg.backgroundColor = UIColor.appColor(.Dark)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
