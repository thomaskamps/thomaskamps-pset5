//
//  DatabaseHelper.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 05-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import SQLite


class DatabaseHelper {
    
    private let lists = Table("lists")
    private let todos = Table("todos")
    
    private let listId = Expression<Int64>("listId")
    private let todoId = Expression<Int64>("todoId")
    private let done = Expression<Bool>("done")
    private let todoTitle = Expression<String>("todoTitle")
    private let listTitle = Expression<String>("listTitle")
    private let todoParent = Expression<Int64>("todoParent")
    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        
        do {
            try db!.run(lists.create(ifNotExists: true) {
                t in
                
                t.column(listId, primaryKey: .autoincrement)
                t.column(listTitle)
            })
        } catch {
            throw error
        }
        
        do {
            try db!.run(todos.create(ifNotExists: true) {
                t in
                
                t.column(todoId, primaryKey: .autoincrement)
                t.column(todoTitle)
                t.column(done)
                t.column(todoParent)
            })
        } catch {
            throw error
        }
    }
    
    /*
    func create(todo: String) throws {
        
        let insert = todos.insert(self.todo <- todo, self.done <- false)
        
        do {
            let rowId = try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    func read() throws -> Array<Any> {
        
        var result: Array<Dictionary<String, Any>> = []
        
        do {
            for res in try db!.prepare(todos) {
                let resDict = ["id": res[id], "todo": res[todo], "done": res[done]] as [String : Any]
                result.append(resDict)
            }
        } catch {
            throw error
        }
        return result
    }
    */
    func clearTable() throws {
        do {
            try db?.run(lists.drop(ifExists: true))
            try db?.run(todos.drop(ifExists: true))
            try createTable()
            
        } catch {
            throw error
        }
    }
    
    func writeList(listTitle: String) throws -> Int {
        let insert = lists.insert(self.listTitle <- listTitle)
        
        do {
            let listId = try db!.run(insert)
            return Int(listId)
        } catch {
            throw error
        }
    }
    
    func writeTodo(todoTitle: String, done: Bool, todoParent: Int) throws {
        let insert = todos.insert(self.todoTitle <- todoTitle, self.done <- done, self.todoParent <- Int64(todoParent))
        
        do {
            try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    func readLists() throws -> Array<Dictionary<String, Any>> {
        
        var result: Array<Dictionary<String, Any>> = []
        
        do {
            for res in try db!.prepare(lists) {
                let resDict = ["id": res[listId], "title": res[listTitle]] as [String : Any]
                result.append(resDict)
            }
        } catch {
            throw error
        }
        return result
    }
    
    func readTodos(id: Int64) throws -> Array<Dictionary<String, Any>> {
        var result: Array<Dictionary<String, Any>> = []
        
        do {
            for res in try db!.prepare(todos) {
                if res[todoParent] == Int64(id) {
                    let resDict = ["title": res[todoTitle], "done": res[done]] as [String : Any]
                    result.append(resDict)
                }
            }
        } catch {
            throw error
        }
        return result
    }
}
