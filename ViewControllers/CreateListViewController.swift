//
//  CreateListViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-27.
//

import UIKit
import Toast


class CreateListViewController: UIViewController {
    
    @IBOutlet weak var createListBtn: UIButton!
    @IBOutlet weak var listNameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    //MARK: -Private
    private func setTheme(){
        createListBtn.setTitleColor(UIColor.appColor(.Dark), for: .normal)
        createListBtn.backgroundColor = UIColor.appColor(.Light)
        createListBtn.layer.cornerRadius = 5
    }
    
    //MARK: -Actions
    @IBAction func createList(_ sender: Any) {
        if let name = listNameTxt.text {
            if name != "" {
                DBHelper.shared.insertList(name: name)
                navigationController?.popViewController(animated: true)
            }else{
                self.view.makeToast("Add a name", duration: 3.0, position: .top)
            }
        }
    }
}
