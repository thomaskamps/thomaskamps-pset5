//
//  DetailViewController.swift
//  thomaskamps-pset5
//
//  Created by Thomas Kamps on 03-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let todoManager = TodoManager.sharedInstance
    var selectedList: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        selectedList = todoManager.getSelectedInt()
        coder.encode(selectedList, forKey: "selectedList")
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        selectedList = coder.decodeInteger(forKey: "selectedList")
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        todoManager.readTodos()
        todoManager.setSelectedList(selectedList: self.selectedList)
    }
    
    /*
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    */
    
    @IBAction func addBarAction(_ sender: Any) {
        self.addTodo()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.addTodo()
    }
    
    func addTodo() {
        
        if todoManager.isSelected() {
            if self.addBar.text != "" {
                
                let todoList = todoManager.getSelectedList()
                todoList.addItem(title: self.addBar.text!)
                self.todoManager.writeTodos()
                self.addBar.text = ""
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRow: Int = 0
        if todoManager.isSelected() {
            let todoList = todoManager.getSelectedList()
            numRow = todoList.getCount()
        } else {
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noList.text             = "No list selected"
            noList.textColor        = UIColor.black
            noList.textAlignment    = .center
            tableView.backgroundView = noList
            tableView.separatorStyle = .none
            numRow = 0
        }
        return numRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        let todoList = todoManager.getSelectedList()
        let todoItem = todoList.getItem(index: indexPath.row)
        let item = todoItem.getItem()
        cell.title.text = item["title"] as! String
        let temp = item["done"] as! Bool
        cell.done.isHidden = !temp
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoList = todoManager.getSelectedList()
        let todoItem = todoList.getItem(index: indexPath.row)
        let item = todoItem.getItem()
        
        let currentDone = item["done"] as! Bool
        let newDone = !currentDone
        todoItem.setDone(done: newDone)
        self.todoManager.writeTodos()
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let todoList = todoManager.getSelectedList()
            todoList.deleteItem(index: indexPath.row)
            self.todoManager.writeTodos()
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }


}
