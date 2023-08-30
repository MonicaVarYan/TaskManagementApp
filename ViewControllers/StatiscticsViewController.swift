//
//  StatiscticsViewController.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-06.
//

import UIKit

class StatiscticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var lists:[List] = []
    
    var completedCountByList: Int = 0
    var totalCountByList:Int = 0
    var completedCount: Int = 0
    var totalCount:Int = 0

    @IBOutlet weak var listsTableView: UITableView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lists = DBHelper.shared.readLists()
        calculateTotalProgress()
        setCountProgress()
        listsTableView.reloadData()
    }
    
    private func calculateProgressByItem(listId: Int) -> Float{
        let completed = DBHelper.shared.countCompletedTaskBy(listId: listId)
        let total = DBHelper.shared.countTasksBy(listId: listId)
        
        return  Float(completed) / Float(total)
    }
    
    private func calculateTotalProgress(){
        let completed = Float(DBHelper.shared.countCompletedTasks())
        let total = Float(DBHelper.shared.countTasks())
        
        var percent: Float = 0.0
        if completed != 0 && total != 0 {
            percent = (completed/total)*100
        }
        
        percentLabel.text = String(Int(percent))+"%"
    }
    
    private func setCountProgress(){
        completedCount = DBHelper.shared.countCompletedTasks()
        totalCount = DBHelper.shared.countTasks()
        countLbl.text = String(completedCount) + " of " + String(totalCount)
    }
    
    private func setTheme(){
        countLbl.textColor = UIColor.appColor(.Dark)
        percentLabel.textColor = UIColor.appColor(.Dark)
    }
    
    
    //MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let avg = calculateProgressByItem(listId: lists[indexPath.row].listId)
        
        completedCountByList = DBHelper.shared.countCompletedTaskBy(listId: lists[indexPath.row].listId)
        totalCountByList = DBHelper.shared.countTasksBy(listId: lists[indexPath.row].listId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell",
                                                 for: indexPath) as! StatisticsTableViewCell
        cell.nameListLbl.text = lists[indexPath.row].name
        cell.listProgress.progress = avg
        cell.countLbl.text = String(completedCountByList) + " of " + String(totalCountByList)
        cell.selectionStyle = .none
        return cell
    }
    
}
