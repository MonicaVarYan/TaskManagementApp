//
//  DBHelper.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-02.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
    }

    let dbPath: String = "taskManagement.sqlite"
    var db:OpaquePointer?

    static let shared = DBHelper()
    //MARK: - Create DB
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!)
            return db
        }
    }
    
    //MARK: - Create Tables
    
    func createListTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS list(ListId INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("list table created.")
            } else {
                print("list table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createTaskTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS task(TasKId INTEGER PRIMARY KEY AUTOINCREMENT, ListId INTEGER, Name TEXT, IsCompleted BOOLEAN, FOREIGN KEY(ListId) REFERENCES list(ListId));"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("task table created.")
            } else {
                print("task table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK: - Inserts
    
    func insertList(name:String)
    {
        let insertStatementString = "INSERT INTO list ( Name) VALUES (?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertTask(listId:Int, name:String, isCompleted:Bool)
    {
        let completed = isCompleted ? 1:0
        let insertStatementString = "INSERT INTO task (ListId, Name, IsCompleted) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(listId))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(completed))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK: - Reads
    
    func readLists() -> [List] {
        let queryStatementString = "SELECT * FROM list;"
        var queryStatement: OpaquePointer? = nil
        var listArray : [List] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                listArray.append(List(listId: Int(id), name: name))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return listArray
    }
    
    func readTasks(listId: Int) -> [Task] {
        let queryStatementString = "SELECT * FROM task WHERE ListId=\(listId);"
        var queryStatement: OpaquePointer? = nil
        var taskArray : [Task] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let taskId = sqlite3_column_int(queryStatement, 0)
                let listId = sqlite3_column_int(queryStatement, 1)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isCompleted = sqlite3_column_int(queryStatement, 3)
                taskArray.append(Task(taskId: Int(taskId), listId: Int(listId), name: name, isCompleted: Bool(truncating: isCompleted as NSNumber)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return taskArray
    }
    
    func readTasksDone(listId: Int) -> [Task] {
        let queryStatementString = "SELECT * FROM task WHERE ListId=\(listId) AND IsCompleted=1;"
        var queryStatement: OpaquePointer? = nil
        var taskArray : [Task] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let taskId = sqlite3_column_int(queryStatement, 0)
                let listId = sqlite3_column_int(queryStatement, 1)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isCompleted = sqlite3_column_int(queryStatement, 3)
                taskArray.append(Task(taskId: Int(taskId), listId: Int(listId), name: name, isCompleted: Bool(truncating: isCompleted as NSNumber)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return taskArray
    }
    
    func readTasksToDo(listId: Int) -> [Task] {
        let queryStatementString = "SELECT * FROM task WHERE ListId=\(listId) AND IsCompleted=0;"
        var queryStatement: OpaquePointer? = nil
        var taskArray : [Task] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let taskId = sqlite3_column_int(queryStatement, 0)
                let listId = sqlite3_column_int(queryStatement, 1)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isCompleted = sqlite3_column_int(queryStatement, 3)
                taskArray.append(Task(taskId: Int(taskId), listId: Int(listId), name: name, isCompleted: Bool(truncating: isCompleted as NSNumber)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return taskArray
    }

    func countTasksBy(listId: Int) -> Int {
        let queryStatementString = "SELECT COUNT(*) FROM task WHERE ListId=\(listId);"
        var queryStatement: OpaquePointer? = nil
        
        var count: Int = 0
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return count
    }
    
    func countCompletedTaskBy(listId: Int) -> Int {
        let queryStatementString = "SELECT COUNT(*) FROM task WHERE ListId=\(listId) AND IsCompleted=1;"
        var queryStatement: OpaquePointer? = nil
        
        var count: Int = 0
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return count
    }
    
    func countTasks() -> Int {
        let queryStatementString = "SELECT COUNT(*) FROM task;"
        var queryStatement: OpaquePointer? = nil
        
        var count: Int = 0
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return count
    }
    
    func countCompletedTasks() -> Int{
        let queryStatementString = "SELECT COUNT(*) FROM task WHERE IsCompleted=1;"
        var queryStatement: OpaquePointer? = nil
        
        var count: Int = 0
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                count = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return count
    }
    
    //MARK: - Updates
    
    func updateNameList(listId: Int, name: String){
        let updateStatementString = "UPDATE list SET Name='\(name)' WHERE ListId=\(listId);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func updateNameTask(taskId: Int, name: String){
        let updateStatementString = "UPDATE task SET Name='\(name)'  WHERE TaskId=\(taskId);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func updateTask(taskId: Int, isCompleted:Bool){
        let completed = isCompleted ? 1:0
        let updateStatementString = "UPDATE task SET IsCompleted=\(completed)  WHERE TaskId=\(taskId);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    

    //MARK: - Deletes
    func deleteListByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM list WHERE ListId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteTaskByListID(id:Int) {
        let deleteStatementStirng = "DELETE FROM task WHERE ListId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteTaskByTaskID(id:Int) {
        let deleteStatementStirng = "DELETE FROM task WHERE TaskId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
