//
//  CreateTaskViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-27.
//

import UIKit

class CreateTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tasks:[[Task]] = [[]]
    var listId: Int = 0
    let defaults = UserDefaults.standard
    
    //MARK: -Outlets
    @IBOutlet weak var taskNameTxt: UITextField!
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var createTaskBtn: UIButton!
    
    //MARK: -Overrrides
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        setTheme()
        refresh()
    }
    
    //MARK: -Private
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
    
    private func refresh(){
        populateArray()
        reOrderTasks()
        tasksTableView.reloadData()
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "TasksTableViewCell",
                                  bundle: nil)
        self.tasksTableView.register(textFieldCell,
                                forCellReuseIdentifier: "TasksTableViewCell")
    }
    
    private func setTheme(){
        createTaskBtn.setTitleColor(UIColor.appColor(.Dark), for: .normal)
        createTaskBtn.backgroundColor = UIColor.appColor(.Light)
        createTaskBtn.layer.cornerRadius = 5
    }
    
    //MARK: -Actions
    @IBAction func createTask(_ sender: Any) {
        if let name = taskNameTxt.text {
            if name != "" {
                DBHelper.shared.insertTask(listId: listId, name: name, isCompleted: false)
                taskNameTxt.text = ""
                refresh()
            }else{
                self.view.makeToast("Add a name", duration: 3.0, position: .top)
            }
        }
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
    
    //MARK: -TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.section][indexPath.row]
        let isCompleted = task.isCompleted ? false : true
        DBHelper.shared.updateTask(taskId: task.taskId, isCompleted: isCompleted)
        refresh()
    }
    
}
