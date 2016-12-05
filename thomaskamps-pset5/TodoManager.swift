//
//  TodoManager.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 05-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    
    private init() { }
    
    private var lists: Array<TodoList> = []
    private var selectedList: Int = 0
    
    func setSelectedList(selectedList: Int) {
        self.selectedList = selectedList
        //reload detailview
    }
    
    func getSelectedList() -> TodoList {
        return self.lists[self.selectedList]
        
    }
    
    func addList(title: String) {
        let todoList = TodoList(title: title)
        self.lists.insert(todoList, at: 0)
        self.setSelectedList(selectedList: 0)
    }
    
    func getCount() -> Int {
        return self.lists.count
    }
    
    func getList(index: Int) -> String {
        return self.lists[index].getTitle()
    }
    
    func deleteList(index: Int) {
        self.lists.remove(at: index)
    }
    
    func getSelectedInt() -> Int {
        return self.selectedList
    }
    
    func isSelected() -> Bool {
        return self.lists.count > self.selectedList
    }
    
    func readTodos() {
        let db = DatabaseHelper()
        self.lists = []
        
        do {
            let read = try db?.readLists()
            for list in read! {
                let items = try db?.readTodos(id: list["id"] as! Int64)
                let addList = TodoList(title: list["title"] as! String)
                for item in items! {
                    addList.addItem(title: item["title"] as! String)
                    let addItem = addList.getItem(index: (addList.getCount()-1))
                    addItem.setDone(done: item["done"] as! Bool)
                }
                self.lists.append(addList)
            }
        } catch {
            print(error)
        }
        
    }
    
    func writeTodos() {
        let db = DatabaseHelper()
        
        do {
            try db?.clearTable()
        } catch {
            print(error)
        }
        
        for list in self.lists {
            
            do {
                
               let listId = try db?.writeList(listTitle: list.getTitle())
                
                for i in 0..<list.getCount() {
                    let item = list.getItem(index: i).getItem()
                    
                    do {
                        try db?.writeTodo(todoTitle: item["title"] as! String, done: item["done"] as! Bool, todoParent: listId!)
                    } catch {
                        print(error)
                    }
                }
                
            } catch {
                print(error)
            }
            
        }
    }
}
