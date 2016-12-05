//
//  TodoItem.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 03-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation

class TodoItem {
    
    private var title: String = ""
    private var done: Bool = false
    
    func setDone(done: Bool) {
        self.done = done
    }
    
    init(title: String) {
        self.title = title
    }
    
    func getItem() -> Dictionary<String, Any> {
        let returnDict:  Dictionary <String, Any> = ["title": self.title, "done": self.done]
        return returnDict
    }
}
