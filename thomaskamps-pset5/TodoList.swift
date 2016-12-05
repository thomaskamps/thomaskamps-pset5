//
//  TodoList.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 05-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation

class TodoList {
    
    private var title: String = ""
    private var items: Array<TodoItem> = []
    
    init(title: String) {
        self.title = title
    }
    
    func addItem(title: String) {
        let item = TodoItem(title: title)
        self.items.append(item)
    }
    
    func getCount() -> Int {
        return items.count
    }
    
    func getItem(index: Int) -> TodoItem {
        return items[index]
    }
    
    func deleteItem(index: Int) {
        self.items.remove(at: index)
    }
    
    func getTitle() -> String {
        return self.title
    }
}
