//
//  StatisticsTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-06.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameListLbl: UILabel!
    @IBOutlet weak var listProgress: UIProgressView!
    @IBOutlet weak var countLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listProgress.progressTintColor = UIColor.appColor(.Dark)
        countLbl.textColor = UIColor.appColor(.Dark)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
