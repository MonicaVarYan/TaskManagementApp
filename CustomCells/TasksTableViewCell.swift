//
//  TasksTableViewCell.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-05.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(name:String, isSelected:Bool){
        nameLbl.text = name
        let checkedImage =  UIImage(named: "checked")!.withRenderingMode(.alwaysTemplate)
        let uncheckedImage =  UIImage(named: "unchecked")!.withRenderingMode(.alwaysTemplate)
        checkedImg.image = isSelected ? checkedImage : uncheckedImage
        checkedImg.tintColor = UIColor.appColor(.Dark)
    }
}
