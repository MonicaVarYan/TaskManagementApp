//
//  TasksViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-27.
//

import UIKit

class TasksViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var listId: Int = 0
    var tasks:[[Task]] = [[]]
    let defaults = UserDefaults.standard
    
    //MARK: -Outlets
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: -Overrrides
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    //MARK: -Private
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "TasksTableViewCell",
                                  bundle: nil)
        self.tasksTableView.register(textFieldCell,
                                forCellReuseIdentifier: "TasksTableViewCell")
    }
    
    private func setTheme(){
        addButton.layer.cornerRadius = 30
        addButton.setTitleColor(UIColor.appColor(.Dark), for: .normal)
        addButton.backgroundColor = UIColor.appColor(.Light)
    }
    
    private func refresh(){
        populateArray()
        reOrderTasks()
        tasksTableView.reloadData()
    }
    
    private func reOrderTasks(){
        if defaults.bool(forKey: "OrderTop") == true {
            for i in 0..<tasks.count {
                tasks[i] = tasks[i].sorted(by: { $0.taskId > $1.taskId } )
            }
        }else {
            for i in 0..<tasks.count {
                tasks[i] = tasks[i].sorted(by: { $0.taskId < $1.taskId } )
            }
        }
    }
    
    private func populateArray(){
        tasks.removeAll()
        if defaults.bool(forKey: "SeparateItems"){
            tasks.append(DBHelper.shared.readTasksToDo(listId: self.listId))
            tasks.append(DBHelper.shared.readTasksDone(listId: self.listId))
        }else {
            tasks.append(DBHelper.shared.readTasks(listId: self.listId))
        }
    }
    
    //MARK: -Actions
    @IBAction func addTask(_ sender: Any) {
        self.performSegue(withIdentifier: "createTaskSegue", sender: self)
    }
    
    //MARK: -TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return defaults.bool(forKey: "SeparateItems") ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if defaults.bool(forKey: "SeparateItems"){
            return section == 0 ? "To Do" : "Done"
        }else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableViewCell",
                                                 for: indexPath) as! TasksTableViewCell

        let task = tasks[indexPath.section][indexPath.row]
            cell.bind(name: task.name, isSelected: task.isCompleted)
            cell.selectionStyle = .none
        
        
        return cell
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.section][indexPath.row]
        
        let editItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Edit List", message: "Enter a new Value", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = task.name
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if let textField = alert?.textFields?[0]{
                    if textField.text != "" {
                        DBHelper.shared.updateNameTask(taskId: task.taskId , name: textField.text!)
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
            let alert = UIAlertController(title: "Delete Task", message: "This task will be delete are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                DBHelper.shared.deleteTaskByTaskID(id: task.taskId)
                self.refresh()
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editItem,deleteItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.section][indexPath.row]
        let isCompleted = task.isCompleted ? false : true
        DBHelper.shared.updateTask(taskId: task.taskId, isCompleted: isCompleted)
        refresh()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createTaskView = segue.destination as! CreateTaskViewController
        if (segue.identifier == "createTaskSegue"){
            createTaskView.listId = self.listId
        }
    }
   
}
