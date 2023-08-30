//
//  ViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-05.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists:[List] = []
    var completedCount: Int = 0
    var totalCount:Int = 0
    var listId: Int = 0
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh(){
        lists = DBHelper.shared.readLists()
        listTableView.reloadData()
    }
    
    func setTheme(){
        addButton.layer.cornerRadius = 30
        addButton.setTitleColor(UIColor.appColor(.Dark), for: .normal)
        addButton.backgroundColor = UIColor.appColor(.Light)
    }
    
    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        completedCount = DBHelper.shared.countCompletedTaskBy(listId: lists[indexPath.row].listId)
        totalCount = DBHelper.shared.countTasksBy(listId: lists[indexPath.row].listId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listsCell",
                                                 for: indexPath) as! ListsTableViewCell
        
        cell.title.text = lists[indexPath.row].name
        cell.detail.text = String(completedCount) + "/" + String(totalCount)
        cell.selectionStyle = .none
        
        return cell
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listId = lists[indexPath.row].listId
        self.performSegue(withIdentifier: "tasksSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let list = self.lists[indexPath.row]
        
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Edit List", message: "Enter a new Value", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = list.name
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields?[0]{
                    if textField.text != "" {
                        DBHelper.shared.updateNameList(listId: list.listId , name: textField.text!)
                        self.refresh()
                    }else{
                        self.view.makeToast("List could not be updated, please set a name.", duration: 5.0, position: .top)
                    }
                }
              
            }))
            
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true)
                self.refresh()
            }))

            self.present(alert, animated: true, completion: nil)
        }
        
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Delete List", message: "All items linked to this list will be delete are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                DBHelper.shared.deleteTaskByListID(id: list.listId) //Delete all tasks linked to this list
                DBHelper.shared.deleteListByID(id: list.listId) // Delete the list
                self.refresh()
                
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
                alert.dismiss(animated: true)
                self.refresh()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editItem,deleteItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tasksSegue"){
            let taskView = segue.destination as! TasksViewController
            taskView.listId = self.listId
            print("Id List \(self.listId)")
        }
    }
}

